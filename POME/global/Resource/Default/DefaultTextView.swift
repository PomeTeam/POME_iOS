//
//  DefaultTextView.swift
//  POME
//
//  Created by 박지윤 on 2022/12/18.
//

import Foundation

class CharactersCountTextView: BaseView{
    
    static let placeholder = "소비에 대한 감상을 적어주세요 (150자)"
    
    let charactersCountLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .body2)
    }
    
    let recordTextView = DefaultTextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style() {
        self.backgroundColor = Color.grey0
        self.layer.cornerRadius = 6
        setTextViewTextEmptyMode()
    }
    
    override func layout(){
        
        self.addSubview(recordTextView)
        self.addSubview(charactersCountLabel)
        
        recordTextView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        charactersCountLabel.snp.makeConstraints{
            $0.top.equalTo(recordTextView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func updateCharactersCount(count: Int){
        
        var countString = "\(count)/150"
        
        if(count < 10){
            countString = "0" + countString
        }
        
        charactersCountLabel.text = countString
    }
    
    func setTextViewTextEmptyMode(){

        charactersCountLabel.textColor = UIColor(red: 173/255, green: 184/255, blue: 205/255, alpha: 1)
        
        recordTextView.setEmptyMode()
        updateCharactersCount(count: 0)
    }
    
    func setTextViewTextEditingMode(){
        charactersCountLabel.textColor = Color.body
        recordTextView.setEditingMode()
    }
}

class DefaultTextView: UITextView{
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style(){
        self.setTypoStyleWithMultiLine(typoStyle: .body2)
        self.backgroundColor = Color.transparent
    }
    
    
    func setEmptyMode(){
        self.text = CharactersCountTextView.placeholder
        self.textColor = Color.grey5
    }
    
    func setEditingMode(){
        self.textColor = Color.body
        self.text = nil
    }
}

