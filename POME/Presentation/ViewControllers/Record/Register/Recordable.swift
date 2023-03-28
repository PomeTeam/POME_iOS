//
//  Recordable.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation
import RxSwift

class Recordable: BaseViewController{
    
    @frozen
    enum RecordType{
        case generate
        case modify
    }
    
    let mainView: RecordContentView
    let viewModel: RecordableViewModel
    
    init(recordType: RecordType, viewModel: RecordableViewModel){
        self.mainView = recordType.mainView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        mainView.completeButton.setTitle(recordType.completeButtonTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension Recordable.RecordType{
    
    var completeButtonTitle: String{
        switch self{
        case .generate:     return "작성했어요"
        case .modify:       return "수정했어요"
        }
    }
    
    var mainView: RecordContentView{
        switch self{
        case .generate:     return RecordRegisterContentView()
        case .modify:       return RecordContentView()
        }
    }
}
