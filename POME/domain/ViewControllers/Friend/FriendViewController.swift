//
//  FriendViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class FriendViewController: BaseTabViewController {
    
    //MARK: - Property
    
    var selectFriendCellIndex: Int = 0
    
    var selectCardCellIndex: Int? //감정 선택 진행 중인 tableView cell index 저장 변수
    
    var friendList = [String?](repeating: nil, count: 10){
        didSet{
            isFriendListEmpty()
        }
    }
    
    var friendCardList = [Reaction?](repeating: nil, count: 13){
        didSet{
            friendView.tableView.reloadData()
        }
    }
    
    //MARK: - UI
    
    let friendView = FriendView()
    
    var emptyFriendView: FriendTableEmptyView?
    
    var emoijiFloatingView: EmojiFloatingView?{
        didSet{
            emoijiFloatingView?.collectionView.delegate = self
            emoijiFloatingView?.collectionView.dataSource = self
        }
    }
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Override
    
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
        
        friendView.collectionView.delegate = self
        friendView.collectionView.dataSource = self
    }
    
    override func topBtnDidClicked() {
        self.navigationController?.pushViewController(FriendSearchViewController(), animated: true)
    }
    
    //MARK: - Method
    private func isFriendListEmpty(){
        
        /*
         친구 리스트 0 -> x
         친구 리스트 x -> 0
         */
        
        if(friendList.isEmpty){
            emptyFriendView = FriendTableEmptyView()
            
            guard let emptyFriendView = emptyFriendView else {
                return
            }

            self.view.addSubview(emptyFriendView)
            
            emptyFriendView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(178)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }

        }else{
            guard let emptyFriendView = emptyFriendView else {
                return
            }
            emptyFriendView.removeFromSuperview()
            self.emptyFriendView = nil
        }
    }
}

//MARK: - CollectionView Delegate
extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == friendView.collectionView ? friendList.count + 1 : 6
    }
    
    //TODO: - By 초기값 설정(select item은 X), 다른 셀 선택해도
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == friendView.collectionView){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.cellIdentifier, for: indexPath)
                    as? FriendCollectionViewCell else { fatalError() }
            
            if(indexPath.row == 0){ //친구 목록 - 전체인 경우
                cell.profileImage.image = Image.categoryInactive
                cell.nameLabel.text = "전체"
            }else{ //친구 목록 - 친구인 경우
                cell.nameLabel.text = "연지뉘"
            }
            
            if(indexPath.row == selectFriendCellIndex){
                cell.setSelectState(row: indexPath.row)
            }
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiFloatingCollectionViewCell.cellIdentifier, for: indexPath)
                    as? EmojiFloatingCollectionViewCell else { fatalError() }
            
            cell.emojiImage.image = Reaction(rawValue: indexPath.row)?.defaultImage
    
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if(collectionView == friendView.collectionView){
            
            if(selectFriendCellIndex == 0 && indexPath.row != 0){
                guard let cell = friendView.collectionView.cellForItem(at: [0,0]) as? FriendCollectionViewCell else { return }
                cell.setUnselectState(row: 0)
            }
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { return }
            
            cell.setSelectState(row: indexPath.row)
            
            self.selectFriendCellIndex = indexPath.row
        }else{
            
            guard let cellIndex = self.selectCardCellIndex, let reaction = Reaction(rawValue: indexPath.row) else { return }
            
            friendCardList[cellIndex] = reaction
            
            self.emoijiFloatingView?.dismiss()
            
            ToastMessageView.generateReactionToastView(type: reaction).show(in: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { return }
        
        cell.setUnselectState(row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if(collectionView == friendView.collectionView){
            return FriendCollectionViewCell.cellSize
        }else{
            return CGSize(width: EmojiFloatingCollectionViewCell.cellWidth, height: EmojiFloatingCollectionViewCell.cellWidth)
        }
    }
    
    
    
    
}

//MARK: - TableView Delegate
extension FriendViewController: UITableViewDelegate, UITableViewDataSource, FriendCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.cellIdentifier, for: indexPath) as? FriendTableViewCell else { fatalError() }

        if let reaction = friendCardList[indexPath.row] {
            cell.mainView.myReactionBtn.setImage(reaction.defaultImage, for: .normal)
        }
        
        cell.mainView.firstEmotionTag.setTagInfo(when: .first, state: .happy)
        cell.mainView.secondEmotionTag.setTagInfo(when: .second, state: .sad)
        
        cell.mainView.setOthersReaction(count: indexPath.row)

        cell.delegate = self
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FriendDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentEmojiFloatingView(indexPath: IndexPath) {
        
        self.selectCardCellIndex = indexPath.row
        
        emoijiFloatingView = EmojiFloatingView()
        
        guard let emoijiFloatingView = emoijiFloatingView,
                let cell = friendView.tableView.cellForRow(at: indexPath) as? FriendTableViewCell else { return }
        
        emoijiFloatingView.dismissHandler = {
            self.selectCardCellIndex = nil
            self.emoijiFloatingView = nil
        }
        
        self.view.addSubview(emoijiFloatingView)

        emoijiFloatingView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        emoijiFloatingView.shadowView.snp.makeConstraints{
            $0.top.equalTo(cell.baseView.snp.bottom).offset(-4)
        }
        
    }
    
    func presentReactionSheet(indexPath: IndexPath) {
        let sheet = FriendReactionSheetViewController()
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
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
