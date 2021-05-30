//
//  UIView+LayoutSpec.swift

import UIKit
import ReactiveSwift
import ReactiveCocoa
import SnapKit

protocol ViewControllerWithSpec: UIViewController {
    associatedtype Spec: LayoutSpecBuildable
    func prepareContentSpec() -> Spec
}

class LayoutSpecViewController: BasicViewController, ViewControllerWithSpec {
    typealias Spec = StackSpec
    
    deinit {
        unbindKeyboard()
    }

    var contentScrollable: Bool {
      get { return scrollView.isScrollEnabled }
      set { scrollView.isScrollEnabled = newValue }
    }
        
    let scrollView = UIScrollView()
    let containerView = UIView()
    let contentView = UIStackView()
    
    override var prefersHomeIndicatorAutoHidden: Bool { return true }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        view.insetsLayoutMarginsFromSafeArea = true
        containerView.insetsLayoutMarginsFromSafeArea = true
        
        let contentSpec = prepareContentSpec()
        contentView.load(spec: contentSpec)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(containerView.layoutMarginsGuide)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview().priority(.required)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            updateBottomConstraint(to: $0.bottom.equalToSuperview().constraint)
        }
        self.view = view
    }
    
    func prepareContentSpec() -> Spec {
        StackSpec(axis: .vertical, distribution: .fill,
                  alignment: .fill, spacing: 12.0,
                  contentInsets: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    func configScroll() {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        containerView.snp.remakeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide).offset(-statusBarHeight).priority(.required)
        }
    }
    
    /// Fixed size content view
    func enableContentFixedSize() {
        contentScrollable = false

        containerView.snp.remakeConstraints {
            $0.edges.size.equalToSuperview()
        }
    }
    
    func layoutWithSafeArea() {
        scrollView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            updateBottomConstraint(to: $0.bottom.equalToSuperview().constraint)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindKeyboard()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.keyboardDismissMode = .onDrag
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unbindKeyboard()
    }
    
    // MARK: - Keyboard
    fileprivate(set) var bottomConstraint: Constraint?
    private var keyboardObserver: Disposable?
    var shouldRespondToKeyboard = false {
        didSet {
            shouldRespondToKeyboard ? bindKeyboard() : unbindKeyboard()
        }
    }
    
    func bindKeyboard() {
        guard shouldRespondToKeyboard, keyboardObserver == nil else { return }
        keyboardObserver = NotificationCenter.default.reactive.keyboard(.didChangeFrame)
            .observe(on: UIScheduler())
            .take(during: reactive.lifetime)
            .debounce(0.1, on: QueueScheduler.main)
            .observeValues { [weak self] context in
                self?.keyboardWillChangeFrame(context)
        }
    }
    
    func unbindKeyboard() {
        keyboardObserver?.dispose()
        keyboardObserver = nil
    }
    
    func keyboardWillChangeFrame(_ context: KeyboardChangeContext) {
        guard shouldRespondToKeyboard, bottomConstraint != nil else { return }
        let keyboardOffset = view.frame.maxY - context.endFrame.minY
        let isShowing = keyboardOffset > 0
        let offset = isShowing ?
            (max(keyboardOffset, context.endFrame.height)) // Showing/Changing
            : 0 // Hiding

        updateLayoutWhenKeyboardChanged(height: offset)
        UIView.animate(withDuration: context.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// Default implementation update `bottomConstraint`.
    /// Override this to provide different UI transition when keyboard appearance changed.
    func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        bottomConstraint?.update(offset: -height)
    }
    
    func updateBottomConstraint(to constraint: Constraint) {
        bottomConstraint = constraint
    }
}
