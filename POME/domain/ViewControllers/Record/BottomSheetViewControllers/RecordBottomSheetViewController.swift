//
//  CannotRecordViewController.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import UIKit

class RecordBottomSheetViewController: BaseSheetViewController {
    
    //MARK: - Properties
    let illuImage = UIImageView().then{
        $0.image = Image.emptyGoal
    }
    let titleLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    let subTitleLabel = UILabel().then{
        $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = Color.grey5
    }
    let cancelButton = UIButton().then{
        $0.setImage(Image.sheetCancel, for: .normal)
    }
    
    //MARK: - LifeCycle
    init(_ icon: UIImage, _ title: String, _ subtitle: String) {
        super.init(nibName: nil, bundle: nil)
        
        illuImage.image = icon
        titleLabel.then{
            $0.text = title
            $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        }
        subTitleLabel.then{
            $0.text = subtitle
            $0.setTypoStyleWithMultiLine(typoStyle: .subtitle2)
            $0.textAlignment = .center
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func style(){
        super.style()
        
        self.setBottomSheetStyle(type: .recordHome)
        titleLabel.text = "지금은 씀씀이를 기록할 수 없어요"
//        subTitleLabel.text = "나만의 소비 목표를 설정하고\n기록을 시작해보세요!"
    }
    
    override func initialize() {
        
        super.initialize()
        
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    override func layout() {
        
        self.view.addSubview(illuImage)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        
        self.view.addSubview(cancelButton)
        
        illuImage.snp.makeConstraints{
            $0.width.height.equalTo(110)
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        cancelButton.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-20)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(illuImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: true)
    }
}
