//
//  ProgressBarView.swift
//  POME
//
//  Created by gomin on 2022/11/22.
//

import UIKit
import SnapKit

final class ProgressBarView: UIView {
    private let progressBarBackView = UIView().then{
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = Color.grey1
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
    }
    private let progressBarView = UIView().then{
        $0.backgroundColor = Color.mint100
    }
    private let numLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)).then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 11
        $0.backgroundColor = Color.mint100
        $0.textColor = .white
        $0.textAlignment = .center
    }
    var ratio: CGFloat = 0.0 {
        didSet {
            // 100% 넘겼을 땐 '초과'
            if !self.ratio.isLess(than: 1.0) {self.overProgressView()}
            // 70% 아래일 땐 초록색
            else if self.ratio.isLess(than: 0.7) {self.commonProgressView()}
            // 70% 이상 100% 아래일 땐 핑크
            else {self.over70ProgressView()}
            numLabel.then{
                let num = Double(ratio) * 100
                if !self.ratio.isLess(than: 1.0) {$0.text = "초과"}
                else {$0.text = "\(Int(num))%"}
                $0.setTypoStyleWithSingleLine(typoStyle: .title5)
            }

            self.progressBarBackView.snp.remakeConstraints {
                $0.height.equalTo(6)
                $0.leading.trailing.centerY.equalToSuperview()
            }
            self.progressBarView.snp.remakeConstraints {
                $0.height.equalTo(6)
                // 초과 또는 0% 일 때 바 길이 조절
                if !self.ratio.isLess(than: 1.0) {
                    $0.width.equalToSuperview().multipliedBy(0.95)
                } else if self.ratio.isLess(than: 0.05) {
                    $0.width.equalToSuperview().multipliedBy(0.05)
                }
                else {
                    $0.width.equalToSuperview().multipliedBy(self.ratio)
                }
            }
            self.numLabel.snp.remakeConstraints {
                $0.centerX.equalTo(progressBarView.snp.trailing)
                $0.centerY.equalTo(progressBarView)
                $0.height.equalTo(22)
            }
        
            UIView.animate(
                withDuration: 0.7,
                delay: 0,
                options: .curveEaseInOut, // In과 Out 부분을 천천히하라는 의미 (나머지인 중간 부분은 빠르게 진행)
                animations: self.layoutIfNeeded, // autolayout에 애니메이션을 적용시키고 싶은 경우 사용
                completion: nil
            )
      }
    }
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)


        self.addSubview(self.progressBarBackView)
        progressBarBackView.addSubview(progressBarView)
        self.addSubview(numLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: - Methods
    func overProgressView() {
        self.progressBarView.backgroundColor = Color.red
        self.numLabel.then{
            $0.backgroundColor = Color.red
        }
    }
    func commonProgressView() {
        self.progressBarView.backgroundColor = Color.mint100
        self.numLabel.then{
            $0.backgroundColor = Color.mint100
        }
    }
    func over70ProgressView() {
        self.progressBarView.backgroundColor = Color.pink100
        self.numLabel.then{
            $0.backgroundColor = Color.pink100
        }
    }
}
