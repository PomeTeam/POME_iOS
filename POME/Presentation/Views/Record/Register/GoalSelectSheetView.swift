//
//  CategorySelectSheetView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

class GoalSelectSheetView: BaseView {
    
    let titleLabel = UILabel().then{
        $0.text = "목표"
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
        $0.textColor = Color.title
    }
    
    let exitButton = UIButton().then{
        $0.setImage(Image.sheetCancel, for: .normal)
    }
    
    let goalTableView = UITableView().then{
        $0.register(cellType: RecordCategoryTableViewCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style() {
        goalTableView.separatorStyle = .none
    }
    
    override func hierarchy() {
        addSubview(titleLabel)
        addSubview(exitButton)
        addSubview(goalTableView)
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(19)
            $0.leading.equalToSuperview().offset(24)
        }
        exitButton.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-24)
        }
        goalTableView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(19)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
