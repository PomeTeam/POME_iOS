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
            self.isHidden = !self.ratio.isLess(than: 1.0)
            numLabel.then{
                let num = Double(ratio) * 100
                $0.text = "\(Int(num))%"
                $0.setTypoStyleWithSingleLine(typoStyle: .title5)
            }

            self.progressBarBackView.snp.remakeConstraints {
                $0.height.equalTo(6)
                $0.leading.trailing.centerY.equalToSuperview()
            }
            self.progressBarView.snp.remakeConstraints {
                $0.height.equalTo(6)
                $0.width.equalToSuperview().multipliedBy(self.ratio)
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
}
