//
//  GoalRegisterSuccessViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class RegisterSuccessViewController: UIViewController {
    
    private let registerType: RegisterSuccessType
    
    init(type: RegisterSuccessType){
        self.registerType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainView = RegisterSuccessView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        initialize()
        emitObservable()
    }
    
    private func style(){
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    private func layout(){
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func initialize() {
        mainView.completeButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)
        bindingData()
    }
    
    private func bindingData(){
        mainView.titleView.titleLabel.text = registerType.title
        mainView.titleView.subtitleLabel.text = registerType.subtitle
        mainView.iconImage.image = registerType.image
    }
    
    private func emitObservable(){
        switch registerType {
        case .goal:     GoalObserver.shared.generateGoal.onNext(Void())
        case .consume:  RecordObserver.shared.generateRecord.onNext(Void())
        }
    }
    
    @objc private func completeButtonDidClicked(){
        navigationController?.popToRootViewController(animated: true)
    }
}
