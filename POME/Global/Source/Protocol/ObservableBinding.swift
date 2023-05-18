//
//  ObservableBinding.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation
import RxSwift

protocol ObservableBinding{
    var disposeBag: DisposeBag { get }
    func bind()
}
