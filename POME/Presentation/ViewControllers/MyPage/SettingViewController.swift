//
//  SettingViewController.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class SettingViewController: BaseViewController {

    // TODO: 알림 설정 제거
    let settingTitleArray = ["친구 관리", "문의 하기", "신고하기", "서비스", "약관 및 정책", "오픈소스 라이센스", "버전 정보", "로그아웃", "탈퇴하기"]
    var settingTableView: UITableView!

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func style() {
        super.style()
        super.setNavigationTitleLabel(title: "설정")
        
        setTableView()
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    // MARK: - Methods
    func setTableView() {
        settingTableView = UITableView().then{
            // 프로필
            $0.register(SettingProfileTableViewCell.self, forCellReuseIdentifier: "SettingProfileTableViewCell")
            // 구분선 있는 셀
            $0.register(SettingWithSeparatorTableViewCell.self, forCellReuseIdentifier: "SettingWithSeparatorTableViewCell")
            // 구분선 없는 셀
            $0.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
            
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = Color.grey0
            $0.tintColor = Color.grey0
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func showLogoutDialog() {
        let dialog = TextPopUpViewController(titleText: "로그아웃 하시겠어요?", greenBtnText: "네", grayBtnText: "아니요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
        
        dialog.okBtn.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    }
    @objc func logoutButtonDidTap() {
        self.logout()
    }
}
// MARK: - TableView delegate
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingTitleArray.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingProfileTableViewCell", for: indexPath) as? SettingProfileTableViewCell else { return UITableViewCell() }
            cell.setUpData()
            cell.selectionStyle = .none
            return cell
        case 1, 2, 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingWithSeparatorTableViewCell", for: indexPath) as? SettingWithSeparatorTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setUpTitle(settingTitleArray[tag - 1])
            return cell
        case 5, 6, 8:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setUpTitle(settingTitleArray[tag - 1])
            return cell
        case 7:
            // Version
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                cell.setUpTitle("\(settingTitleArray[tag - 1]) \(appVersion)")
            } else {
                cell.setUpTitle("\(settingTitleArray[tag - 1])")
            }
            cell.arrow.isHidden = true
            return cell
        case 9:
            let cell = UITableViewCell()
            cell.backgroundColor = Color.grey0
            cell.textLabel?.then{
                $0.text = settingTitleArray[tag - 1]
                $0.setTypoStyleWithSingleLine(typoStyle: .subtitle1)
                $0.textColor = Color.grey5
            }
            cell.textLabel?.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(24)
                make.centerY.equalToSuperview()
            }
            
            return cell
        default:
            let cell = UITableViewCell()
            cell.contentView.backgroundColor = .white
            cell.textLabel?.then{
                $0.text = "서비스"
                $0.setTypoStyleWithSingleLine(typoStyle: .subtitle3)
                $0.textColor = Color.grey5
            }
            cell.textLabel?.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(24)
                make.bottom.equalToSuperview().offset(-4)
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tag = indexPath.row
        switch tag {
        case 0, 1, 2, 3:
            return 71
        case 5, 6, 7, 8, 9:
            return 59
        default:
            return 32
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        switch tag {
        case 1:
            // 친구 관리
            self.navigationController?.pushViewController(MypageFriendViewController(), animated: true)
        case 2:
            // 문의하기
            LinkManager(self, .contact)
        case 3:
            // 신고하기
            LinkManager(self, .report)
//            // 알림 설정
//            self.navigationController?.pushViewController(AlarmSettingViewController(), animated: true)
        case 5:
            LinkManager(self, .privacyAndServiceUse)
        case 6:
            // TODO: 오픈소스 라이센스
            print("")
        case 8:
            // 로그아웃
            showLogoutDialog()
        case 9:
            // 탈퇴하기
            self.navigationController?.pushViewController(DeleteUserViewController(), animated: true)
        default:
            // 버전정보는 클릭 시 아무 동작 안 함.
            print("")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - API
extension SettingViewController {
    func logout() {
        UserService.shared.logout { result in
            switch result{
            case .success(let data):
                if data.self {
                    print("로그아웃 성공")
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
