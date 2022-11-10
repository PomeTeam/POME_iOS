//
//  FriendViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class FriendViewController: BaseTabViewController {
    
    //MARK: - Property
    
    var selectCellIndex: Int? //감정 선택 진행 중인 tableView cell index 저장 변수
    
    var friendList = [String]()
    
    var friendCardList = [Int](repeating: 0, count: 10){
        didSet{
            friendView.tableView.reloadData()
        }
    }
    
    //MARK: - UI
    
    let friendView = FriendView()
    
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
            $0.top.equalTo(self.navigationView.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize() {
        friendView.tableView.delegate = self
        friendView.tableView.dataSource = self
        friendView.tableView.separatorStyle = .none
        
        friendView.collectionView.delegate = self
        friendView.collectionView.dataSource = self
    }
    
    override func topBtnDidClicked() {
        print("top btn did clicked")
    }
}

//MARK: - CollectionView Delegate
extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == friendView.collectionView ? friendList.count + 10 : 6
    }
    
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
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiFloatingCollectionViewCell.cellIdentifier, for: indexPath)
                    as? EmojiFloatingCollectionViewCell else { fatalError() }
            cell.emojiImage.image = UIImage(named: "emoji_\(indexPath.row + 1)")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if(collectionView == friendView.collectionView){
            guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { fatalError() }
            
            cell.setSelectState(row: indexPath.row)
        }else{
            
            guard let cellIndex = self.selectCellIndex else { return }
            
            friendCardList[cellIndex] = indexPath.row + 1
            
            self.emoijiFloatingView?.dismiss()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { return }
        
        cell.setUnselectState(row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if(collectionView == friendView.collectionView){
            return CGSize(width: 52, height: 96)
        }else{
            
            /*
             leftPadding = 29
             rightPadding = 16
             ollectionView left/rightPadding = 16
             spacing = 14
             */
            
            let remainWidth = Const.Device.WIDTH - (29 + 16 * 3 + 14 * 5)
            return CGSize(width: remainWidth/6, height: remainWidth/6)
        }
    }
    
    
    
    
}

//MARK: - TableView Delegate
extension FriendViewController: UITableViewDelegate, UITableViewDataSource, CellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.cellIdentifier, for: indexPath) as? FriendTableViewCell else { fatalError() }
        
        cell.myReactionBtn.setImage(UIImage(named: "emoji_\(friendCardList[indexPath.row])"), for: .normal)
        cell.delegate = self
                
        return cell
    }
    
    func sendCellIndex(indexPath: IndexPath) {
        
        self.selectCellIndex = indexPath.row
        
        emoijiFloatingView = EmojiFloatingView()
        
        guard let emoijiFloatingView = emoijiFloatingView, let cell = friendView.tableView.cellForRow(at: indexPath) as? FriendTableViewCell else { return }
        
        emoijiFloatingView.dismissHandler = {
            self.selectCellIndex = nil
            self.emoijiFloatingView = nil
        }
        
        self.view.addSubview(emoijiFloatingView)

        emoijiFloatingView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        emoijiFloatingView.shadowView.snp.makeConstraints{
            $0.top.equalTo(cell.baseView.snp.bottom).offset(-13)
        }
        
    }
    
    
}
