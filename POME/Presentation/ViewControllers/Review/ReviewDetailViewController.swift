//
//  ReviewDetailViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

protocol ReviewDetailEditable{
    func processResponseModifyRecordInDetail(index: Int, record: RecordResponseModel)
    func processResponseDeleteRecordInDetail(index: Int)
}

class ReviewDetailViewController: BaseViewController {
    
    var delegate: ReviewDetailEditable!
    
    private let goal: GoalResponseModel
    private var record: RecordResponseModel{
        didSet{
            mainView.dataBinding(with: record)
        }
    }
    private let recordIndex: Int
    
    private var emoijiFloatingView: EmojiFloatingView!
    private let mainView = ReviewDetailView()
    
    
    init(recordIndex: Int, goal: GoalResponseModel, record: RecordResponseModel){
        self.recordIndex = recordIndex
        self.goal = goal
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
        FriendReactionSheetViewController(reactions: data).loadAndShowBottomSheet(in: self)
    }
    
    @objc func presentEtcActionSheet() {
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default){ _ in
            alert.dismiss(animated: true)
            let vc = RecordModifyContentViewController(goal: self.goal,
                                                       record: self.record){
                self.record = $0
                self.delegate.processResponseModifyRecordInDetail(index: self.recordIndex, record: self.record)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }

        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            alert.dismiss(animated: true)
            let alert = ImageAlert.deleteRecord.generateAndShow(in: self)
            alert.completion = {
                self.requestDeleteRecord()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
             
        self.present(alert, animated: true)
    }
}

//MARK: - API

extension ReviewDetailViewController{
    
    internal func requestGenerateFriendCardEmotion(reactionIndex: Int){
        guard let reaction = Reaction(rawValue: reactionIndex) else { return }
        
        FriendService.shared.generateFriendEmotion(id: record.id,
                                                   emotion: reactionIndex){ result in
            switch result{
            case .success(let data):
                print("LOG: SUCCESS requestGenerateFriendCardEmotion", data)
                self.record = data
                self.emoijiFloatingView?.dismiss()
                ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
                self.delegate.processResponseModifyRecordInDetail(index: self.recordIndex, record: self.record)
                break
            default:
                print("LOG: fail requestGenerateFriendCardEmotion")
                NetworkAlert.show(in: self){ [weak self] in
                    self?.requestGenerateFriendCardEmotion(reactionIndex: reactionIndex)
                }
                break
            }
        }
    }
    
    private func requestDeleteRecord(){
        RecordService.shared.deleteRecord(id: record.id){ response in
            switch response {
            case .success:
                print("LOG: success requestDeleteRecord")
                self.delegate.processResponseDeleteRecordInDetail(index: self.recordIndex)
                self.navigationController?.popViewController(animated: true)
                break
            default:
                print("LOG: fail requestGetRecords", response)
                NetworkAlert.show(in: self){ [weak self] in
                    self?.requestDeleteRecord()
                }
                break
            }
        }
    }
}
