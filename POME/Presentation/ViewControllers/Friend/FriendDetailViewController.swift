//
//  FriendDetailViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/17.
//

import UIKit

protocol FriendDetailEditable{
    func processResponseModifyReactionInDetail(index: Int, record: RecordResponseModel)
}

class FriendDetailViewController: BaseViewController {
    
    var delegate: FriendDetailEditable!
    private let recordIndex: Int
    private var record: RecordResponseModel{
        didSet{
            mainView.dataBinding(with: record)
        }
    }
    
    private var emoijiFloatingView: EmojiFloatingView!
    private let mainView = FriendDetailView()
    
    init(recordIndex: Int, record: RecordResponseModel){
        self.recordIndex = recordIndex
        self.record = record
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style(){
        super.style()
        self.setNavigationTitleLabel(title: record.nickname)
    }
    
    override func initialize() {
        mainView.myReactionBtn.addTarget(self, action: #selector(presentEmojiFloatingView), for: .touchUpInside)
        mainView.othersReactionButton.addTarget(self, action: #selector(presentReactionSheet), for: .touchUpInside)
        mainView.moreButton.addTarget(self, action: #selector(presentEtcActionSheet), for: .touchUpInside)
        mainView.dataBinding(with: record)
    }
    
    override func layout() {
        
        super.layout()
        
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP + 24)
            $0.leading.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
    }

}

extension FriendDetailViewController: RecordCellWithEmojiDelegate{
    
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
extension FriendDetailViewController{
    func requestGenerateFriendCardEmotion(reactionIndex: Int){
        
        guard let reaction = Reaction(rawValue: reactionIndex) else { return }
        
        FriendService.shared.generateFriendEmotion(id: record.id,
                                                   emotion: reactionIndex){ result in
            switch result{
            case .success(let data):
                print("LOG: success requestGenerateFriendCardEmotion", data)
                self.record = data
                self.emoijiFloatingView?.dismiss()
                ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
                self.delegate.processResponseModifyReactionInDetail(index: self.recordIndex, record: self.record)
                break
            default:
                print("LOG: fail requestGenerateFriendCardEmotion", result)
                NetworkAlert.show(in: self){ [weak self] in
                    self?.requestGenerateFriendCardEmotion(reactionIndex: reactionIndex)
                }
                break
            }
        }
    }
}
