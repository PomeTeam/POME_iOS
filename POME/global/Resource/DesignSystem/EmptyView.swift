//
//  EmptyView.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import Foundation
import UIKit

class EmptyView {
    var tableView: UITableView!
    var collectionView: UICollectionView!
    
    var emptyImage: UIImage!
    var message: String!
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
    }
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func showEmptyView(_ emptyImage: UIImage, _ message: String) {
        let stack = UIView().then{
            $0.backgroundColor = .clear
        }
        let icon = UIImageView().then{
            $0.image = emptyImage
        }
        let messageLabel = UILabel().then{
            $0.textColor = Color.grey5
            $0.text = message
            $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        
        var backgroundView: UIView!
        
        if let tableView = self.tableView {
            backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        } else {
            backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.width, height: self.collectionView.bounds.height))
        }

        stack.addSubview(icon)
        stack.addSubview(messageLabel)
        backgroundView.addSubview(stack)

        stack.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
        }
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.top.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(12)
        }
        messageLabel.textAlignment = .center

        if let tableView = self.tableView {
            tableView.backgroundView = backgroundView
        } else {
            self.collectionView.backgroundView = backgroundView
        }
        
    }
    func hideEmptyView() {
        if let tableView = self.tableView {
            tableView.backgroundView?.isHidden = true
        } else {
            self.collectionView.backgroundView?.isHidden = true
        }
    }
    func setCenterEmptyView(_ emptyImage: UIImage, _ message: String) {
        let stack = UIView().then{
            $0.backgroundColor = .clear
        }
        let icon = UIImageView().then{
            $0.image = emptyImage
        }
        let messageLabel = UILabel().then{
            $0.textColor = Color.grey5
            $0.textAlignment = .center
            $0.text = message
            $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        
        var backgroundView: UIView!
        
        if let tableView = self.tableView {
            backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        } else {
            backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.width, height: self.collectionView.bounds.height))
        }

        stack.addSubview(icon)
        stack.addSubview(messageLabel)
        backgroundView.addSubview(stack)

        stack.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(70)
            make.centerX.centerY.equalToSuperview()
        }
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.top.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(12)
        }

        if let tableView = self.tableView {
            tableView.backgroundView = backgroundView
        } else {
            self.collectionView.backgroundView = backgroundView
        }
    }
}
