//
//  DeleteUserDetailViewController.swift
//  POME
//
//  Created by gomin on 2023/02/06.
//

import UIKit

class DeleteUserDetailViewController: BaseViewController {
    var deleteUserDetailView: DeleteUserDetailView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func style() {
        super.style()
        super.setNavigationTitleLabel(title: "탈퇴하기")
    }
    override func layout() {
        super.layout()
        
        deleteUserDetailView = DeleteUserDetailView()
        self.view.addSubview(deleteUserDetailView)
        deleteUserDetailView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        super.initialize()
        
        deleteUserDetailView.completeButton.rx.tap
            .bind {
                let dialog = TextInfoPopUpViewController(titleText: "탈퇴가 완료되었습니다.", greenBtnText: "확인")
                dialog.modalPresentationStyle = .overFullScreen
                self.present(dialog, animated: false, completion: nil)
                
                dialog.okBtn.addTarget(self, action: #selector(self.deleteUserDidTap), for: .touchUpInside)
            }
            .disposed(by: disposeBag)
    }
    @objc func deleteUserDidTap() {
        print("탈퇴 완료")
        self.dismiss(animated: false)
        
        // TODO: 탈퇴 프로세스 추가 + 탈퇴 완료 후 온보딩으로 이동
    }

}
