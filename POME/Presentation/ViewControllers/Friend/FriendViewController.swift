//
//  FriendViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class FriendViewController: BaseTabViewController, ControlIndexPath {

    var dataIndexBy: (IndexPath) -> Int = { indexPath in
        return indexPath.row - 1
    }
    
    //MARK: - Property
    var currentFriendIndex: Int = 0{
        didSet{
            currentFriendIndex == 0 ? requestGetAllFriendsRecords() : requestGetFriendCards()
        }
    }
    var currentEmotionSelectCardIndex: Int?

    var friends = [FriendsResponseModel](){
        didSet{
            isTableViewEmpty()
            if let friendsCell = friendView.tableView.cellForRow(at: [0,0]) as? FriendListTableViewCell{
                friendsCell.collectionView.reloadData()
            }
        }
    }
    var records = [RecordResponseModel](){
        didSet{
            isTableViewEmpty()
            friendView.tableView.reloadData()
        }
    }
    
    //MARK: - UI
    
    private typealias FriendListTableViewCell = FriendView.FriendListTableViewCell
    
    let friendView = FriendView()
    var emoijiFloatingView: EmojiFloatingView!
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGetFriends()
        print(UserManager.token, UserManager.userId)
    }
    
    override func layout() {
        
        super.layout()
        
        self.view.addSubview(friendView)
        friendView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.bottom.equalToSuperview()
        }
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
    
    private func isTableViewEmpty(){
        if(friends.isEmpty){
            friendView.emptyViewWillShow(case: .nofriend)
        }else if(records.isEmpty){
            friendView.emptyViewWillShow(case: .noRecord)
        }else{
            friendView.emptyViewWillHide()
        }
    }
}

//MARK: - API
extension FriendViewController{
    
    private func requestGetFriends(){
        FriendService.shared.getFriends(pageable: PageableModel(page: 1)){ result in
            switch result{
            case .success(let data):
                    print("LOG: 'success' requestGetFriends", data)
                    self.friends = data
                    self.requestGetAllFriendsRecords()
                break
            default:
                print("LOG: 'fail' requestGetFriends")
                print(result)
                break
            }
        }
    }
    
    private func requestGetAllFriendsRecords(){
        FriendService.shared.getAllFriendsRecord(pageable: PageableModel(page: 0)){ response in
            switch response {
            case .success(let data):
                print("LOG: success requestGetAllFriendsRecords", data)
                self.records = data
            default:
                break
            }
        }
        
    }
    
    private func requestGetFriendCards(){
        
        let friendIndex = currentFriendIndex - 1
        let friendId = friends[friendIndex].friendUserId
        
        FriendService.shared.getFriendRecord(id: friendId,
                                             pageable: PageableModel(page: 0)){ result in
            switch result{
            case .success(let data):
                print("LOG: success requestGetFriendCards", data)
                self.records = data
                break
            default:
                break
            }
        }
    }
    
    func requestGenerateFriendCardEmotion(reactionIndex: Int){
        
        guard let cellIndex = self.currentEmotionSelectCardIndex,
                let reaction = Reaction(rawValue: reactionIndex) else { return }
        
        FriendService.shared.generateFriendEmotion(id: records[cellIndex].id,
                                                   emotion: reactionIndex){ result in
            switch result{
            case .success:
                self.records[cellIndex].emotionResponse.myEmotion = reactionIndex
                self.emoijiFloatingView?.dismiss()
                ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
                break
            default:
                print(result)
                break
            }
        }
    }
}

//MARK: - CollectionView Delegate
extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        friends.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FriendCollectionViewCell.self)
        
        if(indexPath.row == 0){ //친구 목록 - 전체인 경우
            cell.profileImage.image = Image.categoryInactive
            cell.nameLabel.text = "전체"
        }else{ //친구 목록 - 친구인 경우
            cell.nameLabel.text = friends[indexPath.row - 1].friendNickName
            //TODO: - 친구 이미지 바인딩
        }
        
        if(indexPath.row == currentFriendIndex){
            cell.setSelectState(row: indexPath.row)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if(currentFriendIndex == 0 && indexPath.row != 0){
            guard let friendListCell = friendView.tableView.cellForRow(at: [0,0]) as? FriendListTableViewCell,
                    let cell = friendListCell.collectionView.cellForItem(at: [0,0]) as? FriendCollectionViewCell else { return }
            cell.setUnselectState(row: 0)
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { return }
        cell.setSelectState(row: indexPath.row)
        currentFriendIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { return }
        cell.setUnselectState(row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        FriendCollectionViewCell.cellSize
    }
}

//MARK: - TableView Delegate
extension FriendViewController: UITableViewDelegate, UITableViewDataSource, RecordCellWithEmojiDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FriendListTableViewCell.self)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FriendTableViewCell.self)
        let cardIndex = dataIndexBy(indexPath)
        let record = records[cardIndex]
    
        cell.delegate = self
        cell.mainView.dataBinding(with: record)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataIndex = dataIndexBy(indexPath)
        let vc = FriendDetailViewController(record: records[dataIndex])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentEmojiFloatingView(indexPath: IndexPath) {

        self.currentEmotionSelectCardIndex = dataIndexBy(indexPath)
        
        emoijiFloatingView = EmojiFloatingView().then{
            $0.delegate = self
            $0.completion = {
                print("LOG: emoijiFloatingView completion closure called")
                self.currentEmotionSelectCardIndex = nil
                self.emoijiFloatingView = nil
            }
        }

        guard let cell = friendView.tableView.cellForRow(at: indexPath) as? FriendTableViewCell else { return }
        emoijiFloatingView.show(in: self, standard: cell)
    }
    
    func presentReactionSheet(indexPath: IndexPath) {
        let data = records[dataIndexBy(indexPath)].friendReactions
        _ = FriendReactionSheetViewController(reactions: data).loadAndShowBottomSheet(in: self)
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
