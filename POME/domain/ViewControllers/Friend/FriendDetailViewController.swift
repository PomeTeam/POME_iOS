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
    
    let mainView = FriendDetailView().then{
        $0.myReactionBtn.addTarget(self, action: #selector(myReactionBtnDidClicked), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func style(){
        
        super.style()
        
        //MARK: - 지금은 이렇게 넣지만... 데이터 바인딩할 때 데이터 한꺼번에 처리되도록 함수 만들기
        self.setNavigationTitleLabel(title: "닉네임 입력받기")
    }
    
    override func layout() {
        
        super.layout()
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP + 24)
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
        
        emoijiFloatingView.shadowView.snp.makeConstraints{
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
        
        ReactionToastView(type: reaction).show(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: EmojiFloatingCollectionViewCell.cellWidth, height: EmojiFloatingCollectionViewCell.cellWidth)
    }
    
    
}
