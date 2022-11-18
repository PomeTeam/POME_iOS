//
//  EmojiToastView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/17.
//

import UIKit

class ReactionToastView: BaseView {
    
    //MARK: - Properties
    
    let stackView = UIStackView().then{
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    let mashmallowImage = UIImageView().then{
        $0.image = Image.toast
    }
    
    let messageLabel = UILabel().then{
        $0.text = " "
        $0.font = UIFont.autoPretendard(type: .sb_16)
        $0.textColor = .white
    }
    
    
    //MARK: - LifeCycle
    
    init(type reaction: Reaction){
        
        super.init(frame: .zero)
        
        self.messageLabel.text = reaction.toastMessage
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
        
        stackView.addArrangedSubview(mashmallowImage)
        stackView.addArrangedSubview(messageLabel)
    }
    
    override func constraint() {
        
        self.snp.makeConstraints{
            $0.height.equalTo(42)
        }
        
        stackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.centerX.equalToSuperview()
        }
        
        mashmallowImage.snp.makeConstraints{
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
