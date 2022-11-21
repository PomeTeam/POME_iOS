//
//  TermsViewController.swift
//  POME
//
//  Created by gomin on 2022/11/21.
//

import UIKit

class TermsViewController: UIViewController {
    var termsView: TermsView!

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }
    func style() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
    }
    func layout() {
        termsView = TermsView()
        self.view.addSubview(termsView)
        termsView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
class TermCheckButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        
        self.setImage(Image.checkGrey, for: .normal)
        self.setImage(Image.checkGreen, for: .selected)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UILabel {
    func setUnderLine(_ title: String, _ font: UIFont, _ textColor: UIColor) {
        let text = title
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text.count))
        attributeString.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.count))
        attributeString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributeString
    }
}
