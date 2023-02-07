//
//  LoadingTableViewCell.swift
//  POME
//
//  Created by 박소윤 on 2023/02/07.
//

import Foundation

class LoadingTableViewCell: BaseTableViewCell{
    
    let loadingView = UIActivityIndicatorView()
    
    override func hierarchy() {
        super.hierarchy()
        self.baseView.addSubview(loadingView)
    }
    
    override func layout() {
        super.layout()
        loadingView.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    func startLoading(){
        loadingView.startAnimating()
    }
}
