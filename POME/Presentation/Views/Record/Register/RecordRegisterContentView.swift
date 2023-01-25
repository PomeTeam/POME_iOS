//
//  RecordRegisterView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

struct PomeDateFormatter{
    
    static let formatter = DateFormatter().then{
        $0.dateFormat = "yyyy.MM.dd"
    }
    
    static func getTodayDate() -> String{
        return formatter.string(from: Date())
    }
    
    static func getDateString(_ date: CalendarSelectDate) -> String{
        "\(date.year)." + convertIntToFormatterString(date.month) + "." + convertIntToFormatterString(date.date)
    }
    
    static private func convertIntToFormatterString(_ int: Int) -> String{
        int < 10 ? "0\(int)" : String(int)
    }
    
    static func getDateType(from: String){
        formatter.date(from: from)
    }
}

class RecordRegisterContentView: BaseView {
    
    let titleView = RegisterCommonTitleView(title: "어떤 소비를 하셨나요?",
                                            subtitle: "소비에 대한 간단한 기록을 남겨보세요")
    let goalField = CommonRightButtonTextFieldView.generateRightButtonView(image: Image.arrowDown,
                                                                           title: "목표",
                                                                           placeholder: "목표를 선택해주세요")
    let dateField = CommonRightButtonTextFieldView.generateRightButtonView(image: Image.calendar,
                                                                           title: "소비날짜",
                                                                           placeholder: "").then{
        $0.infoTextField.text = PomeDateFormatter.getTodayDate()
    }
    let priceField = RegisterCommonTextFieldView(title: "소비 금액",
                                                  placeholder: "10,000").then{
        $0.infoTextField.keyboardType = .numberPad
    }
    let contentView = UIView()
    let contentTitle = UILabel().then{
        $0.text = "소비 기록"
        $0.font = UIFont.autoPretendard(type: .sb_14)
        $0.textColor = Color.body
    }
    let contentTextView = CharactersCountTextView(type: .consume)
    lazy var completeButton = DefaultButton(titleStr: "작성했어요").then{
        $0.isActivate(false)
    }
    
    //MARK: - Override
    
    override func hierarchy() {
        self.addSubview(titleView)
        self.addSubview(goalField)
        self.addSubview(dateField)
        self.addSubview(priceField)
        self.addSubview(contentTitle)
        self.addSubview(contentTextView)
        self.addSubview(completeButton)
    }
    
    override func layout() {
        titleView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview()
        }
    
        goalField.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        dateField.snp.makeConstraints{
            $0.top.equalTo(goalField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        priceField.snp.makeConstraints{
            $0.top.equalTo(dateField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentTitle.snp.makeConstraints{
            $0.top.equalTo(priceField.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
        }
        
        contentTextView.snp.makeConstraints{
            $0.top.equalTo(contentTitle.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(completeButton.snp.top).offset(-21)
        }
        
        completeButton.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
}
