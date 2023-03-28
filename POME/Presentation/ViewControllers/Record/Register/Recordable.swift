//
//  Recordable.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation

//ViewModel 따로 만들건지 재사용할건지..? 재사용한다면 완료 버튼만 다른데 어떻게 구현할 건지..?
protocol RecordableViewModel{
    
}

class Recordable: BaseViewController{
    
    enum RecordType: String{
        case generate = "작성했어요"
        case modify = "수정했어요"
    }
    
    let mainView: RecordContentView
//    let viewModel: RecordableViewModel
    
    init(recordType: RecordType, mainView: RecordContentView){
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
        mainView.completeButton.setTitle(recordType.rawValue, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
