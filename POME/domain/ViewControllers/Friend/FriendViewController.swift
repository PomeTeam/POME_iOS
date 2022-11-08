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


extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        friendList.count + 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.cellIdentifier, for: indexPath)
                as? FriendCollectionViewCell else { fatalError() }
    
        if(indexPath.row == 0){ //친구 목록 - 전체인 경우
            cell.profileImage.image = Image.categoryInactive
            cell.nameLabel.text = "전체"
        }else{ //친구 목록 - 친구인 경우
            
        }
        
        return cell
    }
    
    
    
    
}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        FriendTableViewCell()
    }
    
    
}
