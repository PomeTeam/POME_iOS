//
//  PomeTextViewTest.swift
//  POME
//
//  Created by 박소윤 on 2023/03/31.
//

import Foundation
import RxSwift

class CountingTextView: BaseView{
    
    private let placeholder: String
    private let countLimit: Int
    
    convenience init(placeholder: String){
        self.init(placeholder: placeholder, countLimit: 150)
    }
    
    init(placeholder: String, countLimit: Int){
        self.placeholder = placeholder
        self.countLimit = countLimit
        super.init(frame: .zero)
        bind()
    }
    
    let textView = UITextView()
    private let countLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .body2)
    }
    private let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style(){
        self.do{
            $0.backgroundColor = Color.grey0
            $0.layer.cornerRadius = 6
        }
        textView.do{
            $0.setTypoStyleWithMultiLine(typoStyle: .body2)
            $0.backgroundColor = Color.transparent
            $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func hierarchy() {
        addSubview(textView)
        addSubview(countLabel)
    }
    
    override func layout() {
        textView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        countLabel.snp.makeConstraints{
            $0.top.equalTo(textView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func bind(){

        let text = textView.rx.text.orEmpty.asObservable()
        
        text
            .element(at: 1)
            .subscribe{ [weak self] in
                $0 == self?.placeholder ? self?.setEmptyMode() : self?.setEditingMode()
            }.disposed(by: disposeBag)
        
        textView.rx.didBeginEditing
            .do(onNext: { [weak self] in
                self?.setFocusState()
            }).withLatestFrom(text)
            .bind(onNext: { [weak self] startText in
                if(startText == self?.placeholder){
                    self?.textView.text = nil
                    self?.setEditingMode()
                }
            }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .do(onNext: { [weak self] in
                self?.setUnfocusState()
            }).withLatestFrom(text)
            .bind(onNext: { [weak self] endText in
                if(endText.isEmpty){
                    self?.textView.text = self?.placeholder
                    self?.setEmptyMode()
                }
            }).disposed(by: disposeBag)
                
        text
            .filter{ [weak self] in
                $0 != self?.placeholder
            }.map{ [self] in
                getValidateRangeString($0)
            }.do{ [weak self] in
                self?.setCountLabelTextColor(count: $0.count)
            }.subscribe(onNext: { [weak self] in
                self?.updateTextAndCount(string: $0)
            }).disposed(by: disposeBag)
    }
    
    private func updateCharactersCount(value count: Int){
        countLabel.text = formatCountString(value: count)
    }
    
    private func formatCountString(value count: Int) -> String{
        
        var countString = "\(count)/\(countLimit)"
        
        if(count < 10){
            countString = "0" + countString
        }
        
        return countString
    }
    
    private func getValidateRangeString(_ value: String) -> String{
        let endIndex = min(countLimit, value.count)
        let endStringIndex = value.index(value.startIndex, offsetBy: endIndex)
        return String(value[..<endStringIndex])
    }
    
    private func setCountLabelTextColor(count: Int){
        countLabel.textColor = count < countLimit ? Color.body : Color.red
    }
    
    private func updateTextAndCount(string: String){
        textView.text = string
        updateCharactersCount(value: string.count)
    }
    
    private func setFocusState(){
        UIView.animate(withDuration: 0.15){
            self.backgroundColor = Color.grey1
        }
    }
    
    private func setUnfocusState(){
        UIView.animate(withDuration: 0.15){
            self.backgroundColor = Color.grey0
        }
    }
    
    private func setEmptyMode(){
        textView.textColor = Color.grey5
        countLabel.textColor = Color.textViewCountGrey
        updateCharactersCount(value: 0)
    }
    
    private func setEditingMode(){
        textView.textColor = Color.body
        countLabel.textColor = Color.body
    }
}
