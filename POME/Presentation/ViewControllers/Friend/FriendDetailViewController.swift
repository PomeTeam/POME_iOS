//
//  FriendDetailViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/17.
//

import UIKit

class FriendDetailViewController: BaseViewController {
    
    var emoijiFloatingView: EmojiFloatingView?{
        didSet{
            emoijiFloatingView?.collectionView.delegate = self
            emoijiFloatingView?.collectionView.dataSource = self
        }
    }
    
    let mainView = FriendDetailView()
    let record: RecordResponseModel
    
    init(record: RecordResponseModel){
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
        mainView.myReactionBtn.addTarget(self, action: #selector(myReactionBtnDidClicked), for: .touchUpInside)
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
    
    @objc func myReactionBtnDidClicked(){
        
        emoijiFloatingView = EmojiFloatingView()
        
        guard let emoijiFloatingView = emoijiFloatingView else { return }
        emoijiFloatingView.dismissHandler = {
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

}

extension FriendDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiFloatingCollectionViewCell.cellIdentifier, for: indexPath)
                as? EmojiFloatingCollectionViewCell else { fatalError() }
        
        cell.emojiImage.image = Reaction(rawValue: indexPath.row)?.defaultImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        guard let reaction = Reaction(rawValue: indexPath.row) else { return }
        
        self.mainView.myReactionBtn.setImage(reaction.defaultImage, for: .normal)
        
        self.emoijiFloatingView?.dismiss()
        
        ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: EmojiFloatingCollectionViewCell.cellWidth, height: EmojiFloatingCollectionViewCell.cellWidth)
    }
    
    
}
