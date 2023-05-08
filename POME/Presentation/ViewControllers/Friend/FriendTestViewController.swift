//
//  FriendTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/05/02.
//

import Foundation
import RxSwift
import RxCocoa

private extension IndexPath{
    var ofFriendData: Int{
        row - 1
    }
    var ofRecordData: Int{
        row - 1
    }
}

final class FriendTestViewController: BaseTabViewController{
    
    private let viewModel: any FriendViewModelInterface
    
    init(viewModel: any FriendViewModelInterface = FriendViewModel()){
        self.viewModel = viewModel
        super.init(btnImage: Image.addPeople)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isRefreshing: Bool{
        guard let refreshControl = mainView.tableView.refreshControl else { return false }
        return refreshControl.isRefreshing
    }
    private var isLoading = false
    
    private let FRIEND_LIST_TABLEVIEW_CELL: IndexPath = [1,0]
    private let COUNT_OF_NOT_RECORD_CELL = 1
    
    private let mainView = FriendView()
    private let reactionFloatingView = ReactionFloatingView()
    
    private let willRefreshData = BehaviorSubject<Void>(value: ())
    private let willPaging = PublishSubject<Void>()
    private let selectedFriendCellIndex = BehaviorRelay(value: 0)
    private let selectedRecordCellIndex = PublishSubject<Int>()
    private let selectedReactionId = PublishSubject<Int>()
    
    override func layout() {
        
        super.layout()
        
        let tabBarHeight = tabBarController?.tabBar.frame.height
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-tabBarHeight!)
        }
    }
    
    override func initialize() {
        setTableViewDelegate()
        setTableViewRefresh()
    }
    
    private func setTableViewDelegate(){
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.separatorStyle = .none
    }
    
    private func setTableViewRefresh(){
        let refreshControl = UIRefreshControl().then{
            $0.backgroundColor = .white
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(refreshingData), for: .valueChanged)
        }
        mainView.tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshingData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.willRefreshData.onNext(())
        }
    }
    
    override func bind() {
        
        guard let viewModel = viewModel as? FriendViewModel else { return }
        
        let input = FriendViewModel.Input(
            refreshView: willRefreshData.asObservable(),
            willPaging: willPaging.asObservable(),
            friendCellIndex: selectedFriendCellIndex.asObservable(),
            recordIndex: selectedRecordCellIndex.asObservable(),
            reactionId: selectedReactionId.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.reloadFriends
            .subscribe(onNext: { [self] in
                mainView.tableView
                    .cellForRow(at: FRIEND_LIST_TABLEVIEW_CELL, cellType: FriendListTableViewCell.self)?
                    .collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        output.reloadRecords
            .subscribe(onNext: { [self] in
                if isLoading {
                    isLoading = false
                }
                if isRefreshing {
                    mainView.tableView.refreshControl?.endRefreshing()
                }
                isTableViewEmpty()
                mainView.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func isTableViewEmpty(){
        if viewModel.friends.isEmpty {
            mainView.emptyViewWillShow(case: .nofriend)
        } else if viewModel.records.isEmpty {
            mainView.emptyViewWillShow(case: .noRecord)
        } else {
            mainView.emptyViewWillHide()
        }
    }
    
    override func topBtnDidClicked() {
        let vc = FriendSearchViewController().then{
            $0.isFromRegister = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FriendTestViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.friends.count + COUNT_OF_NOT_RECORD_CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FriendCollectionViewCell.self)
        switch indexPath.row {
        case 0:     return getAllFriends(cell)
        default:    return getFriend(cell, indexPath: indexPath)
        }
    }
    
    private func getAllFriends(_ cell: FriendCollectionViewCell) -> FriendCollectionViewCell{
        cell.do{
            $0.profileImage.image = Image.categoryInactive
            $0.nameLabel.text = "전체"
        }
        return checkFriendCellSelectState(cell, index: 0)
    }

    private func getFriend(_ cell: FriendCollectionViewCell, indexPath: IndexPath) -> FriendCollectionViewCell{
        let friend = viewModel.friends[indexPath.ofFriendData]
        cell.do{
            $0.nameLabel.text = friend.friendNickName
            $0.profileImage.kf.setImage(with: URL(string: friend.imageKey), placeholder: Image.photoDefault)
        }
        return checkFriendCellSelectState(cell, index: indexPath.row)
    }

    private func checkFriendCellSelectState(_ cell: FriendCollectionViewCell, index: Int) -> FriendCollectionViewCell{
        if index == selectedFriendCellIndex.value {
            cell.setSelectState(row: index)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.cellForItem(at: [0, selectedFriendCellIndex.value], cellType: FriendCollectionViewCell.self)?.do{
            $0.setUnselectState(row: selectedFriendCellIndex.value)
        }
        
        collectionView.cellForItem(at: indexPath, cellType: FriendCollectionViewCell.self)?.do{
            $0.setSelectState(row: indexPath.row)
        }
        selectedFriendCellIndex.accept(indexPath.row)
    }
}

extension FriendTestViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.records.count + COUNT_OF_NOT_RECORD_CELL
        } else if section == 1 && isLoading && viewModel.hasNextPage {
            return 1
        } else {
            return 0
        }
    }
    
    private typealias FriendListTableViewCell = FriendView.FriendListTableViewCell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:     return getFriendTableViewCell(indexPath: indexPath)
        default:    return getLoadingCell(indexPath: indexPath)
        }
    }
    private func getFriendTableViewCell(indexPath: IndexPath) -> BaseTableViewCell {
        switch indexPath.row {
        case 0:     return getFriendsListCell(indexPath: indexPath)
        default:    return getFriendRecordCell(indexPath: indexPath)
        }
    }
    private func getFriendsListCell(indexPath: IndexPath) -> BaseTableViewCell{
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: FriendListTableViewCell.self).then{
            $0.collectionView.delegate = self
            $0.collectionView.dataSource = self
        }
    }
    
    private func getFriendRecordCell(indexPath: IndexPath) -> BaseTableViewCell{
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: FriendTableViewCell.self).then{
            $0.delegate = self
            $0.bindingData(viewModel.records[indexPath.ofRecordData])
        }
    }
    
    private func getLoadingCell(indexPath: IndexPath) -> BaseTableViewCell{
        mainView.tableView.dequeueReusableCell(for: indexPath, cellType: LoadingTableViewCell.self).then{
            $0.startLoading()
        }
    }
}

extension FriendTestViewController: FriendRecordCellDelegate{
    
    func presentReactionSheet(indexPath: IndexPath) {
        let reactions = viewModel.records[indexPath.ofRecordData].friendReactions
        FriendReactionSheetTestViewController(reactions: reactions).show(in: self)
    }
    
    func presentEtcActionSheet(indexPath: IndexPath) {
        
    }
    
    func willShowReactionFloatingView(indexPath: IndexPath) {
        if isSufficientToShowFloatingView(indexPath: indexPath) {
            showReactionFloatingView(indexPath: indexPath)
        } else {
            ToastMessageView.generateMakeSufficientSpaceMessage().show(in: self)
        }
    }
    
    private func isSufficientToShowFloatingView(indexPath: IndexPath) -> Bool {
        
        let rectOfCellInTableView = mainView.tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = mainView.tableView.convert(rectOfCellInTableView, to: view)

        let viewPosition = CGPoint(x: rectOfCellInSuperview.origin.x,
                                   y: rectOfCellInSuperview.origin.y + rectOfCellInSuperview.height)
        
        return Device.HEIGHT - viewPosition.y - view.safeAreaInsets.bottom >= 74
    }
    
    private func showReactionFloatingView(indexPath: IndexPath){
        
        guard let cell = mainView.tableView.cellForRow(at: indexPath) as? FriendTableViewCell else { return }
        
        reactionFloatingView.delegate = self
        reactionFloatingView.show(in: self, standard: cell)
        
        selectedRecordCellIndex.onNext(indexPath.ofRecordData)
    }
    
    func requestGenerateFriendCardEmotion(reactionIndex: Int) {
        
    }
}

extension FriendTestViewController{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if canPaging(offset: offset, contentHeight: contentHeight, height: height) {
            beginPaging()
        }
    }
    
    private func canPaging(offset: CGFloat, contentHeight: CGFloat, height: CGFloat) -> Bool{
        offset > (contentHeight - height) && !isLoading && viewModel.hasNextPage
    }
    
    private func beginPaging(){
        isLoading = true
        DispatchQueue.main.async { [self] in
            mainView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            willPaging.onNext(())
        }
    }
}
