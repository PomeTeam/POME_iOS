//
//  UICollectionView.swift
//  POME
//
//  Created by 박지윤 on 2023/01/18.
//

import Foundation

extension UICollectionView{
    
    final func register<T: BaseCollectionViewCell>(cellType: T.Type) {
        self.register(cellType.self, forCellWithReuseIdentifier: cellType.cellIdentifier)
    }
    
    final func dequeueReusableCell<T: BaseCollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let bareCell = self.dequeueReusableCell(withReuseIdentifier: cellType.cellIdentifier, for: indexPath)
        guard let cell = bareCell as? T else {
          fatalError(
            "Failed to dequeue a cell with identifier \(cellType.cellIdentifier) matching type \(cellType.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
              + "and that you registered the cell beforehand"
          )
        }
        return cell
    }
    
    final func cellForItem<T: BaseCollectionViewCell>(at indexPath: IndexPath, cellType: T.Type) -> T? {
        self.cellForItem(at: indexPath) as? T
    }
}
