//
//  File.swift
//
//
//  Created by Nikola Andriiev on 23.11.16.
//  Copyright © 2016 Andriiev.Mykola. All rights reserved.
//

import Foundation
import UIKit

extension UITableView  {
    
    //DESC: cell csl should macth to identifier
    func headerViewFromCell<T: UITableViewCell>(cls: T.Type) -> UIView {
        let identifier = String(describing: cls.self)
        let cell = self.dequeueReusableCell(withIdentifier: identifier)!
        
        let containerView = UIView(frame: cell.frame)
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(cell)
        
        return containerView
    }
    
    // DESC: cls name should match with cell identifier
    func registerCell<T: UITableViewCell>(_ cls: T.Type) {
        let name = String(describing: cls.self)
        let cell = UINib.init(nibName: name, bundle: nil)
        self.register(cell, forCellReuseIdentifier: name)
    }
    
    func registerHeader(_ cls: AnyClass?) {
        if let cls = cls {
            let name = String(describing: cls.self)
            let nib = UINib.init(nibName: name, bundle: nil)
            self.register(nib, forHeaderFooterViewReuseIdentifier: name)
        }
    }
    
    func dequeueHeader<T>(cls: T.Type) -> T? {
        let clsString = String(describing: T.self)
        return self.dequeueReusableHeaderFooterView(withIdentifier: clsString) as? T
    }
    
    func dequeueCell<T>(cls: T.Type, indexPath path: IndexPath) -> T {
        let clsString = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: clsString, for: path) as? T else {
            fatalError("Can not dequeue cell \(clsString)") }
        return cell
    }
    
    func update(_ block: (() -> ())? = nil) {
        self.beginUpdates()
        block?()
        self.endUpdates()
    }
    
    func estimatedSectionFooterHeaderHeight(height: CGFloat) {
        estimatedSectionHeaderHeight = height
        estimatedSectionFooterHeight = height
    }
    
    func rowAutoHeight(estimatedRowHeight: CGFloat) {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = estimatedRowHeight
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func reloadRowsNoAnimationAt(paths: [IndexPath], animation: UITableView.RowAnimation = .none) {
        let offset = self.contentOffset
        UIView.setAnimationsEnabled(false)
        self.update({
            self.reloadRows(at: paths, with: animation)
        })
        
        self.setContentOffset(offset, animated: false)
        UIView.setAnimationsEnabled(true)
    }
    
    func insertRowNoAnimation(path: IndexPath) {
        self.insertRowsNoAnimation(path: [path])
    }
    
    func insertRowsNoAnimation(path: [IndexPath]) {
        UIView.performWithoutAnimation {
            let offset = self.contentOffset
            self.insertRows(at: path, with: .none)
            self.setContentOffset(offset, animated: false)
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func insertSectionAnimationAt(inx: Int) {
        let offset = self.contentOffset
        UIView.setAnimationsEnabled(false)
        self.update({
            self.insertSections(IndexSet(integer: inx), with: .none)
        })
        
        self.setContentOffset(offset, animated: false)
        UIView.setAnimationsEnabled(true)
    }
}
