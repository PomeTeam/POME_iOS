//
//  AlarmSettingView.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import Foundation
import UIKit

class AlarmSettingView: BaseView {
    let emotionAlarmBackView = UIView().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = Color.pink10
    }
    let emotionAlarmTitleLabel = UILabel().then{
        $0.text = "돌아보기"
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textColor = Color.title
    }
    let emotionAlarmSubTitleLabel = UILabel().then{
        $0.text = "일주일 뒤 감정을 기록할 때 알 수 있어요"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey6
    }
    let emotionAlarmSwitch = UISwitch().then{
        $0.onTintColor = Color.pink100
    }
    let goalCompleteAlarmBackView = UIView().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = Color.grey1
    }
    let goalCompleteAlarmTitleLabel = UILabel().then{
        $0.text = "목표종료"
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        $0.textColor = Color.title
    }
    let goalCompleteAlarmSubTitleLabel = UILabel().then{
        $0.text = "목표가 끝나고 종료할 때 알 수 있어요"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey6
    }
    let goalCompleteAlarmSwitch = UISwitch().then{
        $0.onTintColor = Color.grey5
    }
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Method
    override func style() {
        super.style()
        
    }
    override func hierarchy() {
        super.hierarchy()
        
        addSubview(emotionAlarmBackView)
        addSubview(goalCompleteAlarmBackView)
        
        emotionAlarmBackView.addSubview(emotionAlarmTitleLabel)
        emotionAlarmBackView.addSubview(emotionAlarmSubTitleLabel)
        emotionAlarmBackView.addSubview(emotionAlarmSwitch)
        
        goalCompleteAlarmBackView.addSubview(goalCompleteAlarmTitleLabel)
        goalCompleteAlarmBackView.addSubview(goalCompleteAlarmSubTitleLabel)
        goalCompleteAlarmBackView.addSubview(goalCompleteAlarmSwitch)
    }
    
    override func layout() {
        super.layout()
        
        emotionAlarmBackView.snp.makeConstraints { make in
            make.height.equalTo(76)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(24)
        }
        emotionAlarmTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
        }
        emotionAlarmSubTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(emotionAlarmTitleLabel)
            make.top.equalTo(emotionAlarmTitleLabel.snp.bottom).offset(4)
        }
        emotionAlarmSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        goalCompleteAlarmBackView.snp.makeConstraints { make in
            make.height.equalTo(76)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(emotionAlarmBackView.snp.bottom).offset(14)
        }
        goalCompleteAlarmTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
        }
        goalCompleteAlarmSubTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(goalCompleteAlarmTitleLabel)
            make.top.equalTo(goalCompleteAlarmTitleLabel.snp.bottom).offset(4)
        }
        goalCompleteAlarmSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
