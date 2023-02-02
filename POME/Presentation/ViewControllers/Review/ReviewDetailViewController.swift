//
//  ReviewDetailViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ReviewDetailViewController: BaseViewController {

    let record: RecordResponseModel
    let mainView = ReviewDetailView()
    
    init(record: RecordResponseModel){
        self.record = record
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
//        mainView.myReactionButton.addTarget(self, action: #selector(myReactionBtnDidClicked), for: .touchUpInside)
        mainView.dataBinding(with: record)
    }
    
    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP + 16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    /*
    @objc func myReactionBtnDidClicked(){
        
        emoijiFloatingView = EmojiFloatingView()
        
        guard let emoijiFloatingView = emoijiFloatingView else { return }
        emoijiFloatingView.completion = {
            self.emoijiFloatingView = nil
        }
        
        self.view.addSubview(emoijiFloatingView)
        emoijiFloatingView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        emoijiFloatingView.containerView.snp.makeConstraints{
            $0.top.equalTo(mainView.snp.bottom).offset(20 - 4)
        }
    }
     */
}
