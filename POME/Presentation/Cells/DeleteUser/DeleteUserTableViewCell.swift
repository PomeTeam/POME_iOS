//
//  DeleteUserTableViewCell.swift
//  POME
//
//  Created by gomin on 2023/02/06.
//

import UIKit

class DeleteUserTableViewCell: BaseTableViewCell {
    
    let backGroundView = UIView().then{
        $0.backgroundColor = Color.grey0
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = Color.grey2.cgColor
        $0.layer.borderWidth = 1
    }
    let checkButton = UIButton().then{
        $0.setImage(Image.checkGrey, for: .normal)
        $0.setImage(Image.checkGreen, for: .selected)
    }
    let contentLabel = UILabel().then{
        $0.text = "기록이 귀찮아요"
        $0.setTypoStyleWithSingleLine(typoStyle: .body1)
        $0.textColor = Color.title
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
        
        self.contentView.addSubview(backGroundView)
        backGroundView.addSubview(checkButton)
        backGroundView.addSubview(contentLabel)
    }
    override func layout() {
        super.layout()
        
        backGroundView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.height.equalTo(54)
            make.leading.trailing.equalToSuperview()
        }
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
        }
    }
    func setUpTitle(_ title: String) {
        contentLabel.text = title
    }

}
