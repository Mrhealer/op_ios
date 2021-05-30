//
//  ListViewModel.swift

import Foundation
import ReactiveCocoa
import ReactiveSwift

/// View model for abstracted `ListViewController`
protocol ListViewModel: class {
    var reloadData: Signal<Void, Never> { get }
    var reloadRow: Signal<IndexPath?, Never> { get }
    var cellMapping: [String: UITableViewCell.Type] { get }
    func numberOfRows(in section: Int) -> Int
    func numberOfSections() -> Int
    func cellIdentifier(at indexPath: IndexPath) -> String
    func configure<T: UITableViewCell>(cell: T, at indexPath: IndexPath)
    func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath)
    func didEndDisplayingCell(_ cell: UITableViewCell, at indexPath: IndexPath)
}
