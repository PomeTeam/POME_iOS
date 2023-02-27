//
//  ViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/10/31.
//

import UIKit
import SnapKit
import Then
import RxSwift

class BaseViewController: UIViewController {
    
    let navigationView = UIView()
    let disposeBag = DisposeBag()

    lazy var backBtn = UIButton().then{
        $0.setImage(Image.backArrow, for: .normal)
        $0.addTarget(self, action: #selector(backBtnDidClicked), for: .touchUpInside)
    }
    
    lazy var titleLabel = UILabel().then{
        $0.font = UIFont.autoPretendard(type: .m_14)
        $0.textColor = Color.title
    }
    
    lazy var etcButton = UIButton().then{
        $0.titleLabel?.font = UIFont.autoPretendard(type: .m_14)
        $0.setTitleColor(Color.title, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        style()
        layout()
        initialize()
        bind()
    }
    
    /* BaseViewController method
     
     1. style: ViewController의 property를 변경할 때 사용합니다.
     2. layout: ViewController에 View 추가 및 레이아웃을 설정할 때 사용합니다.
     3. initialize: TableView, CollectionView 등의 delegate를 설정하거나 ViewController 안에서 초기화 작업이 필요한 경우 사용합니다.
    */
    
    func style() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        tabBarController?.tabBar.isHidden = true
        
    }
    
    func layout() {
        
        view.addSubview(navigationView)
        navigationView.addSubview(backBtn)
        
        navigationView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        backBtn.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(backBtn.snp.height)
        }
    }
    
    func initialize() {}
    
    func bind() { }
    
    @objc func backBtnDidClicked(){
        navigationController?.popViewController(animated: true)
    }
    
    func setNavigationTitleLabel(title: String){
        self.titleLabel.text = title
        
        self.navigationView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(14)
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    func setEtcButton(title: String){
        
        self.etcButton.setTitle(title, for: .normal)
        
        self.navigationView.addSubview(etcButton)
        
        etcButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
}

extension BaseViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as? DefaultTextField)?.isFocusState = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? DefaultTextField)?.isFocusState = false
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
