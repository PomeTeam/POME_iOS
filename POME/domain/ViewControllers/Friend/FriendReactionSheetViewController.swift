//
//  FriendReactionSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class FriendReactionSheetViewController: BaseSheetViewController {
    
    //MARK: - Properties
    let mainView = FriendReactionSheetView()
    
    //MARK: - LifeCycle
    
    init(){
        super.init(type: .friendReaction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        
        super.initialize()
        
        mainView.emotionCollectionView.delegate = self
        mainView.emotionCollectionView.dataSource = self
        
        mainView.friendEmotionCollectionView.delegate = self
        mainView.friendEmotionCollectionView.dataSource = self
    }
    
    override func layout() {
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - CollectionViewDelegate
extension FriendReactionSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == mainView.emotionCollectionView ? 7 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == mainView.emotionCollectionView){
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReactionTypeCollectionViewCell.cellIdenifier, for: indexPath) as? ReactionTypeCollectionViewCell else { return UICollectionViewCell() }
            
            if(indexPath.row == 0 && cell.tag == 0){ //0번 인덱스('전체')로 기본값 세팅 위한 코드
                /*
                 cell.tag
                 0: CollectionView 초기 select 값으로 세팅X 상태,
                 1: CollectionView 초기 select 값으로 세팅 완료한 상태
                 */
                cell.setSelectState(row: indexPath.row)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                cell.tag = 1
            }else{
                cell.setUnselectState(row: indexPath.row)
            }
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendReactionCollectionViewCell.cellIdenifier, for: indexPath) as? FriendReactionCollectionViewCell else { return UICollectionViewCell() }
            
            cell.reactionImage.image = Image.emojiSad
            cell.nicknameLabel.text = "기획기획"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == mainView.emotionCollectionView){
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? ReactionTypeCollectionViewCell else { return }
            
            cell.setSelectState(row: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        if(collectionView == mainView.emotionCollectionView){
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? ReactionTypeCollectionViewCell else { return }
            
            cell.setUnselectState(row: indexPath.row)
        }
    }
    
    
}
