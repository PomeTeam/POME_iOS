//
//  AppRegisterViewModel.swift
//  POME
//
//  Created by gomin on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa

class AppRegisterViewModel{
    
    struct Input{
        let phoneTextField: Observable<String>
        let codeTextField: Observable<String>
        let nextButtonControlEvent: ControlEvent<Void>
    }
    
    struct Output{
        let canMoveNext: Driver<Bool>
    }
    
    init(){
//        self.createRecordUseCase = createRecordUseCase
    }
    
    func transform(input: Input) -> Output{
        
        let requestObservable = Observable.combineLatest(input.phoneTextField,
                                                         input.codeTextField)
        
        let canMoveNext = requestObservable
            .map{ [self] phone, code in
                !phone.isEmpty && !code.isEmpty && isValidPhone(phone)
            }.asDriver(onErrorJustReturn: false)
        
        return Output(canMoveNext: canMoveNext)
    }
    func isValidPhone(_ phone: String) -> Bool {
        let pattern = "^01([0-9])([0-9]{3,4})([0-9]{4})$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: phone, options: [], range: NSRange(location: 0, length: phone.count)) {
            return true
        } else {
            return false
        }
    }
}
