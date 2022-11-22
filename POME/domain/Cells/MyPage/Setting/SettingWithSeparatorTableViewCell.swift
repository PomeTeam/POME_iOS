//
//  SettingWithSeparatorTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class SettingWithSeparatorTableViewCell: BaseTableViewCell {
    let backView = UIView().then{
        $0.backgroundColor = .white
    }
    let settingLabel = UILabel().then{
        $0.text = "setting"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle1)
        $0.textColor = Color.title
    }
    let arrow = UIImageView().then{
        $0.image = Image.rightArrowGray5
    }
    let separatorView = UIView().then{
        $0.backgroundColor = Color.grey0
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
        backView.addSubview(settingLabel)
        backView.addSubview(arrow)
        
        self.contentView.addSubview(separatorView)
    }
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(59)
        }
        settingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        arrow.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20.5)
        }
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backView.snp.bottom)
            make.height.equalTo(12)
        }
    }
    func setUpTitle(_ title: String) {
        self.settingLabel.text = title
    }
}
