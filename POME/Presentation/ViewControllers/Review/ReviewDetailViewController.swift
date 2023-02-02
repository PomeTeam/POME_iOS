//
//  ReviewDetailViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ReviewDetailViewController: BaseViewController {
    
    var record: RecordResponseModel
    
    var emoijiFloatingView: EmojiFloatingView!
    let mainView = ReviewDetailView()
    
    init(record: RecordResponseModel){
        self.record = record
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        mainView.myReactionButton.addTarget(self, action: #selector(presentEmojiFloatingView), for: .touchUpInside)
        mainView.othersReactionButton.addTarget(self, action: #selector(presentReactionSheet), for: .touchUpInside)
        mainView.moreButton.addTarget(self, action: #selector(presentEtcActionSheet), for: .touchUpInside)
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
}
extension ReviewDetailViewController: RecordCellWithEmojiDelegate{
    
    @objc func presentEmojiFloatingView() {
        
        emoijiFloatingView = EmojiFloatingView().then{
            $0.delegate = self
            $0.completion = {
                self.emoijiFloatingView = nil
            }
        }
        
        emoijiFloatingView.show(in: self, standard: mainView)
    }
    
    @objc func presentReactionSheet() {
        let data = record.friendReactions
        _ = FriendReactionSheetViewController(reactions: data).loadAndShowBottomSheet(in: self)
    }
    
    @objc func presentEtcActionSheet() {
        
    }
}

//MARK: - API

extension ReviewDetailViewController{
    func requestGenerateFriendCardEmotion(reactionIndex: Int){
        
        guard let reaction = Reaction(rawValue: reactionIndex) else { return }
        
        FriendService.shared.generateFriendEmotion(id: record.id,
                                                   emotion: reactionIndex){ result in
            switch result{
            case .success:
                self.record.emotionResponse.myEmotion = reactionIndex
                self.mainView.myReactionButton.setImage(reaction.defaultImage, for: .normal)
                self.emoijiFloatingView?.dismiss()
                ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
                break
            default:
                break
            }
        }
    }
}
