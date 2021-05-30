//
//  ListViewBridge.swift

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

/// Connection bridge between abstracted `ListViewController` and `UITableView` data source and delegate
class ListViewBridge<VM: ListViewModel>: NSObject,
UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    let viewModel: VM
    private(set) weak var viewController: UIViewController?
    private(set) weak var linkedTableView: UITableView?
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init()
        prepare()
    }
    
    func prepare() {}
    
    func bindViewModel() {
        linkedTableView?.reactive.reloadData <~ viewModel.reloadData
        viewModel.reloadRow.observeValues { [linkedTableView] in
            guard let indexPath = $0 else { return }
            linkedTableView?.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func setViewController(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    /// Render given `tableView` in `parentView`
    func render(tableView: UITableView, in parentView: UIView) {
        parentView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    /// Connect `delegate` and `dataSource` for `tableView`, and then register cells from `viewModel`
    func connect(with tableView: UITableView) {
        self.linkedTableView = tableView
        viewModel.cellMapping.forEach {
            tableView.register($0.value, forCellReuseIdentifier: $0.key)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        bindViewModel()
    }
    
    // MARK: - View lifecycle and properties
    var prefersHomeIndicatorAutoHidden = false
    
    func viewWillAppear(_ animated: Bool) {}
    
    func viewDidDisappear(_ animated: Bool) {}
    
    // MARK: - Table view data source and delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = viewModel.cellIdentifier(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                 for: indexPath)
        viewModel.configure(cell: cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCell(cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        viewModel.didEndDisplayingCell(cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        // Placeholder for subclass overriding
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    
    func scrollToRow(at indexPath: IndexPath) {
        linkedTableView?.scrollToRow(at: indexPath,
                                     at: .bottom,
                                     animated: true)
    }
}
