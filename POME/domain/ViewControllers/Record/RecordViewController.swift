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

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func style() {
        super.style()
        
        recordView.recordTableView.delegate = self
        recordView.recordTableView.dataSource = self
        showEmptyView()
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
    @objc func writeButtonDidTap() {
        let sheet = RecordBottomSheetViewController(Image.emptyGoal, "지금은 씀씀이를 기록할 수 없어요", "나만의 소비 목표를 설정하고\n기록을 시작해보세요!")
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true, completion: nil)
    }
}
//MARK: - CollectionView Delegate
extension RecordViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCollectionViewCell.cellIdentifier, for: indexPath)
                as? GoalCollectionViewCell else { fatalError() }
        cell.goalTitleLabel.text = categoryTitles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let cell = collectionView.cellForItem(at: indexPath) as? GoalCollectionViewCell else { fatalError() }
        cell.isSelected = true
    }
    // 글자수에 따른 셀 너비 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categoryTitles[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.autoPretendard(type: .sb_14)]).width + 32, height: 29)
    }
    
}
// MARK: - TableView delegate
extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCollectionViewTableViewCell", for: indexPath) as? GoalCollectionViewTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.goalCollectionView.delegate = self
            cell.goalCollectionView.dataSource = self
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as? EmptyGoalTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoEmotionBannerTableViewCell", for: indexPath) as? GoEmotionBannerTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCardTableViewCell", for: indexPath) as? RecordCardTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: Empty View
extension RecordViewController {
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
            $0.text = "기록한 씀씀이가 없어요"
            $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: recordView.recordTableView.bounds.width, height: recordView.recordTableView.bounds.height))
        
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
        
        recordView.recordTableView.backgroundView = backgroudView
    }
    func hideEmptyView() {
        recordView.recordTableView.backgroundView?.isHidden = true
    }
}
