//
//  RecordEmotionViewController.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import UIKit

class RecordEmotionViewController: BaseViewController {
    var recordEmotionView = RecordEmotionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func style() {
        super.style()
        
        recordEmotionView.recordEmotionTableView.delegate = self
        recordEmotionView.recordEmotionTableView.dataSource = self
        showEmptyView()
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(recordEmotionView)
        recordEmotionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        super.initialize()
    }
    // MARK: - Actions
    @objc func alertRecordMenuButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction =  UIAlertAction(title: "수정하기", style: UIAlertAction.Style.default){(_) in
            print("click modify")
        }
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = PopUpViewController(Image.trashCan, "기록을 삭제하시겠어요?", "삭제한 내용은 다시 되돌릴 수 없어요", "삭제할게요", "아니요")
            dialog.modalPresentationStyle = .overFullScreen
            self.present(dialog, animated: false, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
// MARK: - TableView delegate
extension RecordEmotionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordEmotionTableViewCell", for: indexPath) as? RecordEmotionTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCardTableViewCell", for: indexPath) as? RecordCardTableViewCell else { return UITableViewCell() }
            // Alert Menu
            cell.menuButton.addTarget(self, action: #selector(alertRecordMenuButtonDidTap), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - Empty View
extension RecordEmotionViewController {
    func showEmptyView() {
        let stack = UIView().then{
            $0.backgroundColor = .clear
        }
        let icon = UIImageView().then{
            $0.image = Image.noting
        }
        let messageLabel = UILabel().then{
            $0.textColor = Color.grey5
            $0.textAlignment = .center
            $0.text = "돌아볼 씀씀이가 없어요"
            $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: recordEmotionView.recordEmotionTableView.bounds.width, height: recordEmotionView.recordEmotionTableView.bounds.height))
        
        stack.addSubview(icon)
        stack.addSubview(messageLabel)
        backgroudView.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
        }
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.top.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(12)
        }
        
        recordEmotionView.recordEmotionTableView.backgroundView = backgroudView
    }
    func hideEmptyView() {
        recordEmotionView.recordEmotionTableView.backgroundView?.isHidden = true
    }
}
