//
//  FriendViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit
import Kingfisher

class FriendViewController: BaseTabViewController, ControlIndexPath, Pageable {

    var dataIndexBy: (IndexPath) -> Int = { indexPath in
        return indexPath.row - 1
    }
    
    //MARK: - Property
    
    var page: Int = 0{
        didSet{
            if(page == 0){
                hasNextPage = false
            }
        }
    }
    var isPaging: Bool = false
    var hasNextPage: Bool = false
    private var willLoadingViewAnimate: Bool{
        page == 0 ? true : false
    }
    
    var currentFriendIndex: Int = 0{
        didSet{
            page = 0
            currentFriendIndex == 0 ? requestGetAllFriendsRecords() : requestGetFriendCards()
        }
    }
    var currentEmotionSelectCardIndex: Int?

    var friends = [FriendsResponseModel](){
        didSet{
            isTableViewEmpty()
            if let friendsCell = friendView.tableView.cellForRow(at: [0,0], cellType: FriendListTableViewCell.self){
                friendsCell.collectionView.reloadData()
            }
            friendImageManager.construct(by: friends)
        }
    }
    var records = [RecordResponseModel](){
        didSet{
            isPaging = false
            isTableViewEmpty()
            friendView.tableView.reloadData()
        }
    }
    
    let friendImageManager = FriendProfileImageManager.shared
    
    //MARK: - UI
    
    private typealias FriendListTableViewCell = FriendView.FriendListTableViewCell
    
    let friendView = FriendView()
    var emoijiFloatingView: EmojiFloatingView!
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGetFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        let vc = FriendSearchViewController()
        vc.isFromRegister = false
        self.navigationController?.pushViewController(vc, animated: true)
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

extension FriendViewController{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        // 스크롤이 테이블 뷰 Offset의 끝에 가게 되면 다음 페이지를 호출
        if offsetY > (contentHeight - height) {
            if isPaging == false && hasNextPage {
                beginPaging()
            }
        }
    }
    
    func beginPaging(){
        
        isPaging = true
        page = page + 1
        
        DispatchQueue.main.async { [self] in
            friendView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentFriendIndex == 0 ? self.requestGetAllFriendsRecords() : self.requestGetFriendCards()
        }
    }
}

//MARK: - API
extension FriendViewController{
    
    private func requestGetFriends(){
        FriendService.shared.getFriends(pageable: PageableModel(page: page)){ result in
            switch result{
            case .success(let data):
                    print("LOG: 'success' requestGetFriends", data)
                    self.friends = data
                    self.requestGetAllFriendsRecords()
                break
            default:
                print("LOG: 'fail' requestGetFriends", result)
                NetworkAlert.show(in: self){ [weak self] in
                    self?.requestGetFriends()
                }
                break
            }
        }
    }
    
    private func requestGetAllFriendsRecords(){
        FriendService.shared.getAllFriendsRecord(pageable: PageableModel(page: page),
                                                 animate: willLoadingViewAnimate){ response in
            switch response {
            case .success(let data):
                print("LOG: success requestGetAllFriendsRecords", data)
                self.processResponseGetRecords(data: data)
                return
            default:
                print("LOG: fail requestGetAllFriendsRecords", response)
                NetworkAlert.show(in: self){ [weak self] in
                    self?.requestGetAllFriendsRecords()
                }
                break
            }
        }
        
    }
    
    private func requestGetFriendCards(){
        
        let friendIndex = currentFriendIndex - 1
        let friendId = friends[friendIndex].friendUserId
        
        FriendService.shared.getFriendRecord(id: friendId,
                                             pageable: PageableModel(page: page),
                                             animate: willLoadingViewAnimate){ result in
            switch result{
            case .success(let data):
                print("LOG: success requestGetFriendCards", data)
                self.processResponseGetRecords(data: data)
                break
            default:
                print("LOG: fail requestGetFriendCards", result)
                NetworkAlert.show(in: self){ [weak self] in
                    self?.requestGetFriendCards()
                }
                break
            }
        }
    }
    
    private func processResponseGetRecords(data: PageableResponseModel<RecordResponseModel>){
        
        hasNextPage = !data.last
        
        if(page == 0){
            records = data.content
        }else{
            records.append(contentsOf: data.content)
        }
        
        if(data.empty){
            recordRequestIsEmpty()
        }
    }
    
    func recordRequestIsEmpty() {
        isPaging = false
        friendView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    
    func requestGenerateFriendCardEmotion(reactionIndex: Int){
        
        guard let cellIndex = self.currentEmotionSelectCardIndex,
                let reaction = Reaction(rawValue: reactionIndex) else { return }
        
        FriendService.shared.generateFriendEmotion(id: records[cellIndex].id,
                                                   emotion: reactionIndex){ result in
            switch result{
            case .success(let data):
                print("LOG: success requestGenerateFriendCardEmotion", data)
                self.records[cellIndex] = data
                self.emoijiFloatingView?.dismiss()
                ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
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
            let friend = friends[indexPath.row - 1]
            cell.nameLabel.text = friend.friendNickName
            cell.profileImage.kf.setImage(with: URL(string: friend.imageKey), placeholder: Image.photoDefault)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return records.count + 1
        }else if(section == 1 && isPaging && hasNextPage){
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LoadingTableViewCell.self)
            cell.startLoading()
            return cell
        }
        
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
        let recordIndex = dataIndexBy(indexPath)
        let record = records[recordIndex]
        let vc = FriendDetailViewController(recordIndex: recordIndex, record: record).then{
            $0.delegate = self
        }
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

extension FriendViewController: FriendDetailEditable{
    func processResponseModifyReactionInDetail(index: Int, record: RecordResponseModel) {
        records[index] = record
    }
}
