//
//  BaseToastMessageView.swift
//  POME
//
//  Created by 박지윤 on 2022/12/26.
//

import UIKit

final class ToastMessage: BaseView {

    private let stackView = UIStackView().then{
        $0.spacing = 8
        $0.axis = .horizontal
    }
    private let toastImage = UIImageView()
    private let messageLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
        $0.textColor = .white
    }
    
    //MARK: - Generator
    
    private init(image: UIImage, message: String){
        super.init(frame: .zero)
        toastImage.image = image
        messageLabel.text = message
    }
    
    static func showHideCompleteMessage(in viewController: UIViewController){
        ToastMessage(image: Image.hide, message: "해당 게시글을 숨겼어요").show(in: viewController)
    }
    
    static func showReactionMessage(type: Reaction, in viewController: UIViewController){
        ToastMessage(image: Image.toast, message: type.toastMessage).show(in: viewController)
    }
    
    static func showMakeSufficientSpaceMessage(in viewController: UIViewController){
        ToastMessage(image: Image.toastSufficientSpace, message: "스크롤을 올리면 이모지를 남길 수 있어요!").show(in: viewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    
    override func style() {
        layer.cornerRadius = 42 / 2
        clipsToBounds = true
        backgroundColor = UIColor(
            red: 78/255,
            green: 82/255,
            blue: 86/255,
            alpha: 0.8
        )
    }
    
    override func hierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(toastImage)
        stackView.addArrangedSubview(messageLabel)
    }
    
    override func layout() {
        self.snp.makeConstraints{
            $0.height.equalTo(42)
        }
        stackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.centerX.equalToSuperview()
        }
        toastImage.snp.makeConstraints{
            $0.width.height.equalTo(20)
        }
        messageLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Method
    
    func show(in vc: UIViewController){
        addToParent(vc)
        setLayout()
        startAnimation(vc)
    }
    
    private func addToParent(_ vc: UIViewController){
        vc.view.addSubview(self)
    }
    
    private func setLayout(){
        self.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-119)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func startAnimation(_ vc: UIViewController){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.transform = CGAffineTransform(translationX: 0, y: -25)
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 0) {
                    self.transform = .identity
                } completion: { finished in
                    UIView.animate(withDuration: 0.5, delay: 0.3,animations: {
                        self.transform = CGAffineTransform(translationX: 0, y: 80)
                        self.layer.opacity = 0.0
                    }, completion:{ finished in
                        self.removeFromSuperview()
                        if vc.extensionContext != nil {
                            vc.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                        }
                    })
                }
            }
        }
    }
    
}
