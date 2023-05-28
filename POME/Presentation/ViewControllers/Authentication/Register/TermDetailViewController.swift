//
//  TermDetailViewController.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import UIKit

class TermDetailViewController: BaseViewController {
    let termTitleLabel = UILabel().then{
        $0.text = "개인 정보보호 동의"
        $0.numberOfLines = 0
        $0.setTypoStyleWithSingleLine(typoStyle: .header1)
    }
    let contentLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.text = "포미은 ~수집을 위해 아래와 같이 개인정보를 수집, 이용하고자 합니다. 내용을 읽으신 후 동의 여부를 결정하여 주십시오.\n\n개인정보 수집 이용 내역\n수집, 이용 항목 : 이름, 휴대전화 번호\n수집, 이용 목적 : ~ 수집\n개인정보 보관기간 : 수집일로부터 1년\n\n수집된 개인정보는 ~에 한해 이용되며, 목적 달성 후 안전하게 파기 됩니다. 개인 정보 수집 및 이용에 대해 거부하실 수 있으며, 동의를 거부하실 경우 ~ 불가합니다."
        $0.setTypoStyleWithMultiLine(typoStyle: .body2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func layout() {
        super.layout()
        
        self.view.addSubview(termTitleLabel)
        self.view.addSubview(contentLabel)
        
        termTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(super.navigationView.snp.bottom).offset(8)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(termTitleLabel.snp.bottom).offset(25)
        }
    }
}
