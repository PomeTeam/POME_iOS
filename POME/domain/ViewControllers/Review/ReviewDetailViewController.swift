//
//  ReviewDetailViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ReviewDetailViewController: BaseViewController {

    let mainView = ReviewDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP + 16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
