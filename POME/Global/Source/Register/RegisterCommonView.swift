//
//  GoalCommonView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class RegisterCommonTitleView: BaseView{
    
    let titleLabel = UILabel().then{
        $0.setTypoStyleWithMultiLine(typoStyle: .title1)
        $0.textColor = Color.title
        $0.numberOfLines = 2
    }
    
    let subtitleLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
        $0.numberOfLines = 1
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    init(title: String, subtitle: String){
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
    }
    
    override func layout() {
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subtitleLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
        }
    }
}

class RegisterCommonTextFieldView: BaseView{
    
    let fieldTitleLabel = UILabel().then{
        $0.font = UIFont.autoPretendard(type: .sb_14)
        $0.textColor = Color.body
    }
    
    let infoTextField = DefaultTextField()
    
    init(title: String, placeholder: String){
        super.init(frame: .zero)
        self.fieldTitleLabel.text = title
        self.infoTextField.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style() {
        self.infoTextField.addRightPadding(16)
    }
    
    override func hierarchy() {
        self.addSubview(fieldTitleLabel)
        self.addSubview(infoTextField)
    }
    
    override func layout() {
        
        fieldTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        infoTextField.snp.makeConstraints{
            $0.top.equalTo(fieldTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(46)
        }
    }
}

class CommonRightButtonTextFieldView: RegisterCommonTextFieldView{
    
    lazy var rightImage = UIImageView()
    
    private override init(title: String, placeholder: String){
        super.init(title: title, placeholder: placeholder)
    }
    
    static func generateRightButtonView(image: UIImage, title: String, placeholder: String) -> CommonRightButtonTextFieldView{
        
        let view = CommonRightButtonTextFieldView(title: title, placeholder: placeholder).then{
            $0.rightImage.image = image
        }
        
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style() {
        infoTextField.addRightPadding(50)
        infoTextField.isUserInteractionEnabled = false
    }
    
    override func hierarchy() {
        
        super.hierarchy()

        infoTextField.addSubview(rightImage)
    }
    
    override func layout() {

        super.layout()
        
        rightImage.snp.makeConstraints{
            $0.top.equalToSuperview().offset(11)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(rightImage.snp.height)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
}
