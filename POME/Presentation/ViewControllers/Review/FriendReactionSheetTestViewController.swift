//
//  FriendReactionSheetTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/04/03.
//

import Foundation
import RxSwift

class FriendReactionSheetTestViewController: BaseSheetViewController, ObservableBinding{
    
    @frozen
    enum CollectionView: Int { //rawValue > view tag
        case reaction = 100
        case friendReaction = 200
    }
    
    let disposeBag = DisposeBag()
    private let viewModel: FriendReactionSheetViewModel
    private let mainView = FriendReactionSheetView()
    private let reactions: [FriendReactionResponseModel]
    
    init(reactions: [FriendReactionResponseModel]){
        self.reactions = reactions
        viewModel = FriendReactionSheetViewModel(allReactions: reactions)
        super.init(type: .friendReaction)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func initialize() {
        super.initialize()
        setCollectionViewDelegate([mainView.reactionCollectionView,
                                   mainView.friendReactionCollectionView])
        setCollectionViewTag()
    }
    
    private func setCollectionViewDelegate(_ collectionViews: [UICollectionView]){
        collectionViews.forEach{
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    private func setCollectionViewTag(){
        mainView.reactionCollectionView.tag = CollectionView.reaction.rawValue
        mainView.friendReactionCollectionView.tag = CollectionView.friendReaction.rawValue
    }
    
    func bind() {
        let output = viewModel.transform(FriendReactionSheetViewModel.Input())
        
        output.selectReactionCount
            .drive(onNext: { [weak self] in
                self?.mainView.countLabel.text = "전체 \($0)개"
            }).disposed(by: disposeBag)
        
        output.tableViewReload
            .drive(onNext: { [weak self] _ in
                self?.mainView.friendReactionCollectionView.reloadData()
                self?.mainView.reactionCollectionView.reloadData()
            }).disposed(by: disposeBag)
    }
}

extension FriendReactionSheetTestViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    private func getCollectionViewType(tag: Int) -> CollectionView{
        guard let type = CollectionView(rawValue: tag) else { fatalError("유효하지 않은 collection view tag 값") }
        return type
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch getCollectionViewType(tag: collectionView.tag){
        case .reaction:         return 7
        case .friendReaction:   return viewModel.getFriendsReactionCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch getCollectionViewType(tag: collectionView.tag){
        case .reaction:
            return bindingReactionCell(collectionView, indexPath: indexPath)
        case .friendReaction:
            return bindingFriendReactionCell(collectionView, indexPath: indexPath)
        }
    }
    
    private func bindingReactionCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> ReactionTypeCollectionViewCell{
        return collectionView.dequeueReusableCell(for: indexPath, cellType: ReactionTypeCollectionViewCell.self).then{
            viewModel.selectedReaction() == indexPath.row ? $0.setSelectState(row: indexPath.row) : $0.setUnselectState(row: indexPath.row)
        }
    }
    
    private func bindingFriendReactionCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> FriendReactionCollectionViewCell{
        let reactionInfo = viewModel.getFriendReaction(at: indexPath.row)
        return collectionView.dequeueReusableCell(for: indexPath, cellType: FriendReactionCollectionViewCell.self).then{
            $0.reactionImage.image = Reaction(rawValue: reactionInfo.emotionId)?.defaultImage
            $0.nicknameLabel.text = reactionInfo.nickname
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (getCollectionViewType(tag: collectionView.tag) != .reaction) {
            return
        }
        collectionView.cellForItem(at: indexPath, cellType: ReactionTypeCollectionViewCell.self).do{
            viewModel.selectReaction(id: indexPath.row)
            $0.setSelectState(row: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if (getCollectionViewType(tag: collectionView.tag) != .reaction) {
            return
        }
        collectionView.cellForItem(at: indexPath, cellType: ReactionTypeCollectionViewCell.self).do{
            $0.setUnselectState(row: indexPath.row)
        }
    }
    
}
