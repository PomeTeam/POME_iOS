//
//  FriendTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import UIKit

class FriendTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties

    static let cellIdentifier = "FriendTableViewCell"
    
    var delegate: CellDelegate?
    
    let mainView = FriendDetailView().then{
        $0.myReactionBtn.addTarget(self, action: #selector(myReactionBtnDidClicked), for: .touchUpInside)
        
        $0.memoLabel.numberOfLines = 2
    }
    
    //
    let separatorLine = UIView().then{
        $0.backgroundColor = Color.grey2
        
    }
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    
    @objc func myReactionBtnDidClicked(){
        
        guard let index = getCellIndex() else { return }

        delegate?.sendCellIndex(indexPath: index)
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        
        super.hierarchy()
        
        self.baseView.addSubview(mainView)
        self.baseView.addSubview(separatorLine)
    }
    
    override func layout() {
        
        super.layout()
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        separatorLine.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

}
