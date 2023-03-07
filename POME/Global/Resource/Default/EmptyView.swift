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
    
    let stack = UIView().then{
        $0.backgroundColor = .clear
    }
    let icon = UIImageView()
    let messageLabel = UILabel().then{
        $0.textColor = Color.grey5
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
    }
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func hierachy() {
        setUpEmptyContent()
        
        stack.addSubview(icon)
        stack.addSubview(messageLabel)
    }
    func layout() {
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.top.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(12)
        }
        messageLabel.textAlignment = .center
    }
    func setUpEmptyContent() {
        self.icon.image = self.emptyImage
        self.messageLabel.text = self.message
    }
    
    func showEmptyView(_ emptyImage: UIImage, _ message: String) {
        self.emptyImage = emptyImage
        self.message = message
        
        hierachy()
        layout()
        
        if let tableView = self.tableView {
            tableView.backgroundView = stack
            
            stack.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(450)
            }
        } else {
            self.collectionView.backgroundView = stack
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
        self.emptyImage = emptyImage
        self.message = message
        
        hierachy()
        layout()

        if let tableView = self.tableView {
            tableView.backgroundView = stack
            stack.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        } else {
            self.collectionView.backgroundView = stack
        }
    }
}
