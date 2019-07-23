//
//  UICollectionView+Extension.swift
//  Seravi
//
//  Created by Alexey Trotsenko on 12.01.2018.
//  Copyright © 2018 Alexey Trotsenko. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    //DESC: cell csl should macth to identifier
    func registerCell<T: UICollectionViewCell>(_ cls: T.Type) {
        let name = String(describing: cls.self)
        let cell = UINib.init(nibName: name, bundle: nil)
        self.register(cell, forCellWithReuseIdentifier: name)
    }
    
    func dequeueCell<T>(cls: T.Type, indexPath path: IndexPath) -> T {
        let clsString = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: clsString, for: path) as? T else {
            fatalError("Can not dequeue cell \(clsString)") }
        return cell
    }
    
    func registerHeaderView(_ cls: AnyClass?) {
        if let cls = cls {
            let name = String(describing: cls.self)
            self.register(cls, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name)
        }
    }

    func dequeueHeaderView<T>(cls: T.Type, indexPath: IndexPath) -> T {
        let clsString = String(describing: T.self)
        guard let headerView = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: clsString, for: indexPath) as? T else {fatalError("Error get supplementary view")}
        return headerView
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
