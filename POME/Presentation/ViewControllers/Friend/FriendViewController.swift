//
//  FriendViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class FriendViewController: BaseTabViewController {
    
    //MARK: - Property
    var currentFriendIndex: Int = 0{
        willSet{
            requestGetFriendCards()
        }
    }
    var currentEmotionSelectCardIndex: Int?{
        get{
            self.currentEmotionSelectCardIndex ?? nil
        }
        set(value){
            self.currentEmotionSelectCardIndex = value == nil ? nil : value! - 1
        }
    }

    var friends = [FriendsResponseModel](){
        didSet{
            isFriendListEmpty()
            friendView.tableView.reloadData()
        }
    }

    var friendCards = [RecordResponseModel](){
        didSet{
            friendView.tableView.reloadData()
        }
    }
    
    //MARK: - UI
    
    private typealias FriendListTableViewCell = FriendView.FriendListTableViewCell
    
    let friendView = FriendView()
    var emptyFriendView: FriendTableEmptyView?
    var emoijiFloatingView: EmojiFloatingView?{
        didSet{
            emoijiFloatingView?.collectionView.delegate = self
            emoijiFloatingView?.collectionView.dataSource = self
        }
    }
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGetFriends()
    }
    
    override func layout() {
        
        super.layout()
        
        self.view.addSubview(friendView)
        friendView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        isFriendListEmpty()
    }
    
    override func initialize() {
        friendView.tableView.delegate = self
        friendView.tableView.dataSource = self
        friendView.tableView.separatorStyle = .none
    }
    
    override func topBtnDidClicked() {
        self.navigationController?.pushViewController(FriendSearchViewController(), animated: true)
    }
    
    //MARK: - Method
    
    private func isFriendListEmpty(){
        
        if(friends.isEmpty){
            
            emptyFriendView = FriendTableEmptyView()
            guard let emptyFriendView = emptyFriendView else { return }

            self.view.addSubview(emptyFriendView)
            emptyFriendView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(178)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }else{
            guard let emptyFriendView = emptyFriendView else { return }
            emptyFriendView.removeFromSuperview()
            self.emptyFriendView = nil
        }
    }
}

//MARK: - API
extension FriendViewController{
    
    private func requestGetFriends(){
        
        FriendService.shared.getFriends(pageable: PageableModel(page: 1,
                                                                size: 10)){ result in
            switch result{
            case .success(let data):
                self.friends = data
                self.requestGetFriendCards()
                break
            default:
                break
            }
        }
    }
    
    private func requestGetFriendCards(){
        let friendId = friends[currentFriendIndex].friendUserId
        FriendService.shared.getFriendRecord(id: friendId,
                                             pageable: PageableModel(page: 0, size: 10)){ result in
            switch result{
            case .success(let data):
                self.friendCards = data
                break
            default:
                break
            }
        }
    }
    
    private func requestGenerateFriendCardEmotion(reactionIndex: Int){
        
        guard let cellIndex = self.currentEmotionSelectCardIndex,
                let reaction = Reaction(rawValue: reactionIndex) else { return }
        
        FriendService.shared.generateFriendEmotion(id: friendCards[cellIndex].id,
                                                   emotion: reactionIndex){ result in
            switch result{
            case .success:
                self.friendCards[cellIndex].emotionResponse.myEmotion = reactionIndex
                self.emoijiFloatingView?.dismiss()
                ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
                break
            default:
                break
            }
        }
    }
}

//MARK: - CollectionView Delegate
extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == emoijiFloatingView?.collectionView ? 6 : friends.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if(collectionView == emoijiFloatingView?.collectionView){
            
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: EmojiFloatingCollectionViewCell.self)
            cell.emojiImage.image = Reaction(rawValue: indexPath.row)?.defaultImage
    
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FriendCollectionViewCell.self)
            
            if(indexPath.row == 0){ //친구 목록 - 전체인 경우
                cell.profileImage.image = Image.categoryInactive
                cell.nameLabel.text = "전체"
            }else{ //친구 목록 - 친구인 경우
                cell.nameLabel.text = "연지뉘"
            }
            
            if(indexPath.row == currentFriendIndex){
                cell.setSelectState(row: indexPath.row)
            }
            
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if(collectionView == emoijiFloatingView?.collectionView){
            requestGenerateFriendCardEmotion(reactionIndex: indexPath.row)
        }else{
            
            if(indexPath.row == currentFriendIndex){
                return
            }
            
            if(currentFriendIndex == 0 && indexPath.row != 0){
                guard let friendListCell = friendView.tableView.cellForRow(at: [0,0]) as? FriendListTableViewCell, let cell = friendListCell.collectionView.cellForItem(at: [0,0]) as? FriendCollectionViewCell else { return }
                cell.setUnselectState(row: 0)
            }
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { return }
            cell.setSelectState(row: indexPath.row)
            
            self.currentFriendIndex = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { return }
        cell.setUnselectState(row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if(collectionView == emoijiFloatingView?.collectionView){
            return CGSize(width: EmojiFloatingCollectionViewCell.cellWidth, height: EmojiFloatingCollectionViewCell.cellWidth)
        }
        return FriendCollectionViewCell.cellSize
    }
}

//MARK: - TableView Delegate
extension FriendViewController: UITableViewDelegate, UITableViewDataSource, FriendCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendCards.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FriendListTableViewCell.self)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FriendTableViewCell.self)
        let cardIndex = indexPath.row - 1
        let record = friendCards[cardIndex]
    
        cell.delegate = self
        cell.mainView.dataBinding(with: record)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FriendDetailViewController(record: friendCards[indexPath.row - 1])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentEmojiFloatingView(indexPath: IndexPath) {
        
        self.currentEmotionSelectCardIndex = indexPath.row - 1
        
        emoijiFloatingView = EmojiFloatingView()
        
        guard let emoijiFloatingView = emoijiFloatingView,
              let cell = friendView.tableView.cellForRow(at: indexPath) as? FriendTableViewCell else { return }
        emoijiFloatingView.dismissHandler = {
            self.currentEmotionSelectCardIndex = nil
            self.emoijiFloatingView = nil
        }
        
        self.view.addSubview(emoijiFloatingView)
        emoijiFloatingView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        emoijiFloatingView.containerView.snp.makeConstraints{
            $0.top.equalTo(cell.baseView.snp.bottom).offset(-4)
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                emoijiFloatingView.containerView.transform = CGAffineTransform(translationX: 0, y: -10)
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 0) {
                    emoijiFloatingView.containerView.transform = .identity
                }
            }
            
        }
    }
    
    func presentReactionSheet(indexPath: IndexPath) {
        _ = FriendReactionSheetViewController().loadAndShowBottomSheet(in: self)
    }
    
    func presentEtcActionSheet(indexPath: IndexPath) {
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let hideAction = UIAlertAction(title: "숨기기", style: .default){ _ in
            alert.dismiss(animated: true)
            ToastMessageView.generateHideToastView().show(in: self)
        }

        let declarationAction = UIAlertAction(title: "신고하기", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(hideAction)
        alert.addAction(declarationAction)
        alert.addAction(cancelAction)
             
        self.present(alert, animated: true)
    }
    
    
}
