//
//  RecordCardTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import UIKit

class RecordCardTableViewCell: BaseTableViewCell {
    let backView = UIView().then{
        $0.backgroundColor = .systemCyan
        $0.setShadowStyle(type: .card)
    }

    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func setting() {
        super.setting()
        
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(backView)
    }
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(6)
            make.height.equalTo(182)
        }
    }
}
