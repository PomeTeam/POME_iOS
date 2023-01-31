//
//  MypageGoalsTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class MypageGoalsTableViewCell: BaseTableViewCell {
    let backView = UIView().then{
        $0.backgroundColor = Color.pink10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
    }
    let bannerIcon = UIImageView().then{
        $0.image = Image.circlePink
    }
    let titleLabel = UILabel().then{
        $0.text = "목표 보관함"
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
        $0.textColor = Color.title
    }
    let subTitleLabel = UILabel().then{
        $0.text = "다시 보고 싶은 지난 목표가 2건 있어요"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey6
    }
    let arrow = UIImageView().then{
        $0.image = Image.rightArrowPink
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
        backView.addSubview(bannerIcon)
        backView.addSubview(titleLabel)
        backView.addSubview(subTitleLabel)
        backView.addSubview(arrow)
    }
    override func layout() {
        super.layout()
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(74)
            make.top.bottom.equalToSuperview()
        }
        bannerIcon.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerIcon.snp.top)
            make.leading.equalTo(bannerIcon.snp.trailing).offset(10)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bannerIcon.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-14)
        }
        arrow.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-14)
        }
    }
}
//MARK: - API
// TODO: 완료한 목표 보관함
//extension MypageGoalsTableViewCell {
//    public func getGoalCounts(){
//        GoalServcie.shared.getUserGoals{ result in
//            switch result{
//            case .success(let data):
//                self.subTitleLabel.text = "다시 보고 싶은 지난 목표가 \(data.content.count)건 있어요"
//
//                break
//            default:
//                print(result)
//                break
//            }
//        }
//    }
//}
