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
        deleteUser()
    }

}

// MARK: - API
extension DeleteUserDetailViewController {
    func deleteUser() {
        UserService.shared.logout { result in
            switch result{
            case .success(let data):
                if data.self {
                    print("탈퇴 완료")
                    self.dismiss(animated: false)
                    
                    // 유저 정보 삭제
                    UserDefaults.standard.removeObject(forKey: UserDefaultKey.token)
                    UserDefaults.standard.removeObject(forKey: UserDefaultKey.userId)
                    UserDefaults.standard.removeObject(forKey: UserDefaultKey.nickName)
                    UserDefaults.standard.removeObject(forKey: UserDefaultKey.profileImg)
                    UserDefaults.standard.removeObject(forKey: UserDefaultKey.phoneNum)
                    
                    self.navigationController?.pushViewController(OnboardingViewController(), animated: true)
                    self.dismiss(animated: false)
                }
                
                break
            default:
                print(result)
                break
            }
        }
    }
}
