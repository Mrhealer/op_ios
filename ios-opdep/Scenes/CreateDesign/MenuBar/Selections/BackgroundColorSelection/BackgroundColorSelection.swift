//
//  ColorView.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 06/05/2021.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class BackgroundColorSelection: PassthroughView {
    let header = UIView()
    
    let categoryBarView: GridView<DesignGridViewModel>
    let viewModel: BackgroundColorSelectionViewModel
    
    init(viewModel: BackgroundColorSelectionViewModel) {
        self.viewModel = viewModel
        categoryBarView = .init(viewModel: viewModel.designGridViewModel)
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        isHidden = true
        let stackSpec = StackSpec(axis: .vertical)
        stackSpec.add(header, categoryBarView)
        buildHeader()
        let stackView = PassthroughStackView()
        stackView.load(spec: stackSpec)
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        header.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        viewModel.isSelected.signal.observeValues { [weak self] in
            if $0 {
                self?.show()
            } else {
                self?.isHidden = true
            }
        }
    }
    
    func buildHeader() {
        header.backgroundColor = UIColor.Basic.white
        header.whiteShadow()
        let doneButton = StyleButton(image: R.image.confirm_icon())
        let labelTitle = StyleLabel(text: Localize.Editor.attributecolor,
                                    font: .font(style: .medium, size: 14),
                                    textAlignment: .center)
        header.addSubviews(doneButton, labelTitle)
        doneButton.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        labelTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        doneButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    @objc func hide() {
        viewModel.isSelected.swap(false)
    }
    
    private func show() {
//        viewModel.fetchFrames()
    }
}
