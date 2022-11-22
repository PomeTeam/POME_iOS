//
//  SettingTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class SettingTableViewCell: BaseTableViewCell {
    let settingLabel = UILabel().then{
        $0.text = "setting"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle1)
        $0.textColor = Color.title
    }
    let arrow = UIImageView().then{
        $0.image = Image.rightArrowGray5
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
        
        self.contentView.backgroundColor = .white
        self.contentView.tintColor = .white
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(settingLabel)
        self.contentView.addSubview(arrow)
    }
    override func layout() {
        super.layout()
        
        settingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        arrow.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20.5)
        }
    }
    func setUpTitle(_ title: String) {
        self.settingLabel.text = title
    }
}
