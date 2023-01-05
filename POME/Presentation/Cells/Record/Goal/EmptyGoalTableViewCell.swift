//
//  GoalTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/11.
//
import UIKit

class EmptyGoalTableViewCell: BaseTableViewCell {
    let backView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.borderColor = Color.grey2.cgColor
        $0.layer.borderWidth = 1
        $0.setShadowStyle(type: .card)
    }
    let emptyGoalImage = UIImageView().then{
        $0.image = Image.mintMarshmallow
    }
    let titleLabel = UILabel().then{
        $0.text = "목표를 세워 친구와\n마시멜로를 모아보세요!"
        $0.setTypoStyleWithMultiLine(typoStyle: .title3)
        $0.numberOfLines = 0
    }
    let makeGoalButton = UIButton().then{
        $0.setTitle("목표 만들기 >", for: .normal)
        $0.setTitleColor(Color.mint100, for: .normal)
        $0.titleLabel?.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        super.baseView.backgroundColor = Color.transparent
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(backView)
        backView.addSubview(emptyGoalImage)
        backView.addSubview(titleLabel)
        backView.addSubview(makeGoalButton)
    }
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
            make.height.equalTo(157)
        }
        emptyGoalImage.snp.makeConstraints { make in
            make.width.height.equalTo(98)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(emptyGoalImage.snp.trailing).offset(30)
            make.top.equalToSuperview().offset(44)
        }
        makeGoalButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
    }
}
