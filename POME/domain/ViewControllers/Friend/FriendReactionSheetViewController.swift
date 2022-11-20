//
//  FriendReactionSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class FriendReactionSheetViewController: BaseSheetViewController {
    
    //MARK: - Properties
    var selectReaction: Int = 0
    
    let mainView = FriendReactionSheetView()
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func style(){
        
        super.style()
        
        self.setBottomSheetStyle(type: .friendReaction)
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
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReactionTypeCollectionViewCell.cellIdenifier, for: indexPath) as? ReactionTypeCollectionViewCell else { fatalError() }
            
            if(indexPath.row == selectReaction && indexPath.row == 0){ //0번 인덱스일 때만 실행되는 코드
                cell.setSelectState(at: indexPath.row)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            }else{
                cell.setUnselectState(at: indexPath.row)
            }
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendReactionCollectionViewCell.cellIdenifier, for: indexPath) as? FriendReactionCollectionViewCell else { fatalError() }
            
            cell.reactionImage.image = Image.emojiSad
            cell.nicknameLabel.text = "기획기획"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("new cell is select", indexPath)
        if(collectionView == mainView.emotionCollectionView){
            guard let cell = collectionView.cellForItem(at: indexPath) as? ReactionTypeCollectionViewCell else { return }
            
            cell.setSelectState(at: indexPath.row)
            
            selectReaction = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("change unselect", indexPath)
        if(collectionView == mainView.emotionCollectionView){
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? ReactionTypeCollectionViewCell else { return }
            
            cell.setUnselectState(at: indexPath.row)
        }
    }
    
    
}
