//
//  GridView.swift

import Foundation
import UIKit

class GridView<T: GridViewModel>: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let viewModel: T
    let collectionView: UICollectionView
    init(viewModel: T) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = viewModel.scrollDirection
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        backgroundColor = viewModel.backgroundColor
        collectionView.backgroundColor = viewModel.backgroundColor
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(viewModel.padding)
            $0.trailing.equalToSuperview().offset(-viewModel.padding)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.cellMapping.forEach {
            collectionView.register($0.value, forCellWithReuseIdentifier: $0.key)
        }
        collectionView.isPagingEnabled = viewModel.isPagingEnabled
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        viewModel.reloadData.startWithValues { [collectionView] _ in
            collectionView.reloadData()
        }
        
        viewModel.currentIndexPath.signal.skipNil()
            .observeValues { [collectionView] in
                collectionView.scrollToItem(at: $0,
                                            at: .centeredHorizontally,
                                            animated: true)
        }
    }
    
    // MARK: - CollectionView Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = viewModel.cellIdentifier(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath)
        viewModel.configure(cell: cell,
                            at: indexPath)
        return cell
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath: indexPath)
    }
    
    // MARK: - CollectionView FlowLayout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = viewModel.sizeForItem(collectionView: collectionView, indexPath: indexPath) {
            return size
        }
        var itemWidth: CGFloat = 0
        var itemHeight: CGFloat = 0
        guard viewModel.itemsPerUnit != 1 else {
            if viewModel.scrollDirection == .horizontal {
                itemWidth = collectionView.bounds.height - viewModel.itemSpacing * 2
                itemHeight = itemWidth
            } else {
                itemHeight = collectionView.bounds.width - viewModel.itemSpacing * 2
                itemWidth = itemHeight
            }
            
            return CGSize(width: itemWidth,
                          height: itemHeight)
        }
        let space = viewModel.itemSpacing * CGFloat(viewModel.itemsPerUnit - 1)
        if viewModel.scrollDirection == .horizontal {
            itemHeight = (collectionView.bounds.height - space) / CGFloat(viewModel.itemsPerUnit)
            itemWidth = itemHeight
        } else {
            itemWidth = (collectionView.bounds.width - space) / CGFloat(viewModel.itemsPerUnit)
            itemHeight = itemWidth
        }
        return CGSize(width: itemWidth,
                      height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        viewModel.contentInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        viewModel.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        viewModel.interitemSpacing
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { }
}
