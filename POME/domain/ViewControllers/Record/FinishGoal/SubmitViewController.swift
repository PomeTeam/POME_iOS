//
//  SubmitViewController.swift
//  POME
//
//  Created by gomin on 2022/11/24.
//

import UIKit

class SubmitViewController: UIViewController {

    // MARK: - Views
    let titleLabel = UILabel().then{
        $0.text = "종료된 목표를\n목표 보관함에 저장했어요"
        $0.numberOfLines = 0
        $0.setTypoStyleWithMultiLine(typoStyle: .title1)
        $0.textColor = Color.title
    }
    let subTitleLabel = UILabel().then{
        $0.text = "저장된 목표와 코멘트는\n시간이 지나도 확인할 수 있어요"
        $0.numberOfLines = 0
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
    }
    let image = UIImageView().then{
        $0.image = Image.paperMint
    }
    let completeButton = DefaultButton(titleStr: "확인했어요")

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }

    // MARK: - Functions
    func style() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        
    }
    func layout() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(image)
        self.view.addSubview(completeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(60)
            make.leading.equalToSuperview().offset(20)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
        }
        image.snp.makeConstraints { make in
            make.width.height.equalTo(270)
            make.centerX.centerY.equalToSuperview()
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-35)
        }
    }
}
