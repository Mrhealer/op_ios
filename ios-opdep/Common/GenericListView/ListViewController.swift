//
//  ListViewController.swift

import UIKit

/// Abstracted content list view
/// Subclass `ListViewBrdige` or provide a view model which implements `ListViewModel`
class ListViewController<VM: ListViewModel>: BasicViewController {
    private var viewModel: VM { bridge.viewModel }
    private let bridge: ListViewBridge<VM>
    var tableView = UITableView()
    init(viewModel: VM) {
        self.bridge = ListViewBridge(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        bridge.setViewController(self)
    }
    
    init(bridge: ListViewBridge<VM>) {
        self.bridge = bridge
        super.init(nibName: nil, bundle: nil)
        bridge.setViewController(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
        bridge.render(tableView: tableView, in: view)
        bridge.connect(with: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bridge.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bridge.viewDidDisappear(animated)
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        bridge.prefersHomeIndicatorAutoHidden
    }
}
