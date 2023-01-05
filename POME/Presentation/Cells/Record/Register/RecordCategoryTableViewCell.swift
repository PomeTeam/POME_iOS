//
//  RecordCategoryTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/12/17.
//

import UIKit

class RecordCategoryTableViewCell: BaseTableViewCell {
    
    static let cellIdentifier = "RecordCategoryTableViewCell"
    
    let nameLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle1)
        $0.textColor = Color.body
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy(){
        
        super.hierarchy()
        
        baseView.addSubview(nameLabel)
    }
    
    override func layout(){
        
        super.layout()
        
        nameLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
    }
    
}
