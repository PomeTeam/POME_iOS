//
//  BaseToastMessageView.swift
//  POME
//
//  Created by 박지윤 on 2022/12/26.
//

import UIKit

class ToastMessageView: BaseView {
    
    //MARK: - Properties
    
    let stackView = UIStackView().then{
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    let toastImage = UIImageView()
    
    let messageLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
        $0.textColor = .white
    }
    
    
    //MARK: - LifeCycle
    
    private init(image: UIImage, message: String){
        super.init(frame: .zero)
        self.toastImage.image = image
        self.messageLabel.text = message
    }
    
    static func generateHideToastView() -> ToastMessageView{
        return ToastMessageView(image: Image.hide, message: "해당 게시글을 숨겼어요")
    }
    
    static func generateReactionToastView(type: Reaction) -> ToastMessageView{
        return ToastMessageView(image: Image.toast, message: type.toastMessage)
    }
    
    static func generateMakeSufficientSpaceMessage() -> ToastMessageView{
        return ToastMessageView(image: Image.toastSufficientSpace, message: "스크롤을 올리면 이모지를 남길 수 있어요!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    
    override func style() {

        self.backgroundColor = UIColor(red: 78/255,
                                       green: 82/255,
                                       blue: 86/255,
                                       alpha: 0.8)
        
        self.layer.cornerRadius = 42 / 2
        self.clipsToBounds = true
    }
    
    override func hierarchy() {
        
        self.addSubview(stackView)
        
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
    
    func show(in viewController: UIViewController){

        viewController.view.addSubview(self)
        
        self.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-119)
            $0.centerX.equalToSuperview()
        }
        
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
                        if viewController.extensionContext != nil {
                            viewController.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                        }
                    })
                }
            }
        }
    }
    
}
