//
//  RecordViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//
import UIKit

class RecordViewController: BaseTabViewController {
    var recordView = RecordView()
    var categoryTitles = ["목표1", "목표2", "목표3목표3목표3목표3", "목표4", "목표5", ]
    var categorySelectedIdx = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func style() {
        super.style()
        
        recordView.recordTableView.delegate = self
        recordView.recordTableView.dataSource = self
        EmptyView(recordView.recordTableView).showEmptyView(Image.noting, "기록한 씀씀이가 없어요")
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(recordView)
        recordView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        super.initialize()
        
        recordView.writeButton.addTarget(self, action: #selector(writeButtonDidTap), for: .touchUpInside)
    }
    // MARK: - Actions
    override func topBtnDidClicked() {
        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    @objc func writeButtonDidTap() {
        let sheet = RecordBottomSheetViewController(Image.flagMint, "지금은 씀씀이를 기록할 수 없어요", "나만의 소비 목표를 설정하고\n기록을 시작해보세요!")
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
    }
    @objc func cannotAddGoalButtonDidTap() {
        let sheet = RecordBottomSheetViewController(Image.ten, "목표는 10개를 넘을 수 없어요", "포미는 사용자가 무리하지 않고 즐겁게 목표를\n달성할 수 있도록 응원하고 있어요!")
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
    }
    func cannotAddEmotionDidTap() {
        let sheet = RecordBottomSheetViewController(Image.penPink, "아직은 감정을 기록할 수 없어요", "일주일이 지나야 감정을 남길 수 있어요\n나중에 다시 봐요!")
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
    }
    @objc func alertGoalMenuButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImagePopUpViewController(Image.trashGreen, "목표를 삭제하시겠어요?", "해당 목표에서 작성한 기록도 모두 삭제돼요", "삭제할게요", "아니요")
            dialog.modalPresentationStyle = .overFullScreen
            self.present(dialog, animated: false, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    @objc func alertRecordMenuButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction =  UIAlertAction(title: "수정하기", style: UIAlertAction.Style.default){(_) in
            print("click modify")
        }
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImagePopUpViewController(Image.trashGreen, "기록을 삭제하시겠어요?", "삭제한 내용은 다시 되돌릴 수 없어요", "삭제할게요", "아니요")
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
//MARK: - CollectionView Delegate
extension RecordViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCategoryCollectionViewCell.cellIdentifier, for: indexPath)
                as? GoalCategoryCollectionViewCell else { fatalError() }
        
        cell.goalCategoryLabel.text = categoryTitles[indexPath.row]
        if indexPath.row == self.categorySelectedIdx {cell.setSelectState()}
        else if indexPath.row == 4 {cell.setInactivateState()}  //임시
        else {cell.setUnselectState()}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.categorySelectedIdx = indexPath.row
        self.recordView.recordTableView.reloadData()
        return true
    }
    // 글자수에 따른 셀 너비 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categoryTitles[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.autoPretendard(type: .sb_14)]).width + 32, height: 29)
    }
    
}
// MARK: - TableView delegate
extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCategoryTableViewCell", for: indexPath) as? GoalCategoryTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.goalCollectionView.delegate = self
            cell.goalCollectionView.dataSource = self
            cell.goalCollectionView.reloadData()
            
            // Add Goal
            cell.goalPlusButton.addTarget(self, action: #selector(cannotAddGoalButtonDidTap), for: .touchUpInside)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as? GoalTableViewCell else { return UITableViewCell() }
            // Alert Menu
            cell.menuButton.addTarget(self, action: #selector(alertGoalMenuButtonDidTap), for: .touchUpInside)
            cell.selectionStyle = .none
            
            // 목표 종료 셀 (임시)
            if self.categorySelectedIdx == 4 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FinishGoalTableViewCell", for: indexPath) as? FinishGoalTableViewCell else { return UITableViewCell() }
                return cell
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoEmotionBannerTableViewCell", for: indexPath) as? GoEmotionBannerTableViewCell else { return UITableViewCell() }
            
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
        let tag = indexPath.row
        if tag == 2 {
            self.navigationController?.pushViewController(RecordEmotionViewController(), animated: true)
        } else if tag > 2 {
            cannotAddEmotionDidTap()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
