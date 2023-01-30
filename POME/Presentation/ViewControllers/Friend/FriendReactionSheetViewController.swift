//
//  FriendReactionSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class FriendReactionSheetViewController: BaseSheetViewController {
    
    //MARK: - Properties
    var currentReaction: Int = 0
    var filterReactions: [FriendReactionResponseModel]!{
        didSet{
            mainView.friendReactionCollectionView.reloadData()
        }
    }
    let reactions: [FriendReactionResponseModel]
    
    let mainView = FriendReactionSheetView()
    
    //MARK: - LifeCycle
    
    init(reactions: [FriendReactionResponseModel]){
        self.filterReactions = reactions
        self.reactions = reactions
        super.init(type: .friendReaction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        
        super.initialize()
        
        mainView.emotionCollectionView.delegate = self
        mainView.emotionCollectionView.dataSource = self
        
        mainView.friendReactionCollectionView.delegate = self
        mainView.friendReactionCollectionView.dataSource = self
    }
    
    override func layout() {
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func filterReactionBy(id: Int){
        if(id == 0){
            filterReactions = reactions
            return
        }
        filterReactions = reactions.filter{ $0.id == id - 1 }
    }
}

//MARK: - CollectionViewDelegate
extension FriendReactionSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == mainView.emotionCollectionView ? 7 : filterReactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == mainView.emotionCollectionView){
            
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ReactionTypeCollectionViewCell.self)
            currentReaction == indexPath.row ? cell.setSelectState(row: indexPath.row) : cell.setUnselectState(row: indexPath.row)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FriendReactionCollectionViewCell.self)
            let data = filterReactions[indexPath.row]
            cell.reactionImage.image = Reaction(rawValue: data.id)?.defaultImage
            cell.nicknameLabel.text = data.name
    
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == mainView.emotionCollectionView){
            guard let cell = collectionView.cellForItem(at: indexPath) as? ReactionTypeCollectionViewCell else { return }
            cell.setSelectState(row: indexPath.row)
            filterReactionBy(id: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(collectionView == mainView.emotionCollectionView){
            guard let cell = collectionView.cellForItem(at: indexPath) as? ReactionTypeCollectionViewCell else { return }
            cell.setUnselectState(row: indexPath.row)
        }
    }
}
