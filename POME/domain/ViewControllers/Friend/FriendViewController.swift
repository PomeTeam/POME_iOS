//
//  FriendViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class FriendViewController: BaseTabViewController {
    
    //MARK: - Property
    
    var friendList = [String]()
    
    let friendView = FriendView()
    
    let emoijiFloatingView = EmojiFloatingView()
    
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
        
        emoijiFloatingView.collectionView.delegate = self
        emoijiFloatingView.collectionView.dataSource = self
    }
    
    override func topBtnDidClicked() {
        print("top btn did clicked")
    }
}

//MARK: - CollectionView Delegate
extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        friendList.count + 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.cellIdentifier, for: indexPath)
                as? FriendCollectionViewCell else { fatalError() }
    
        if(indexPath.row == 0){ //친구 목록 - 전체인 경우
            cell.profileImage.image = Image.categoryInactive
            cell.nameLabel.text = "전체"
        }else{ //친구 목록 - 친구인 경우
            cell.nameLabel.text = "연지뉘"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { fatalError() }
        
        cell.setSelectState(row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else { return }
        
        cell.setUnselectState(row: indexPath.row)
    }
    
    
    
    
}

//MARK: - TableView Delegate
extension FriendViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        FriendTableViewCell()
    }
    
    
}
