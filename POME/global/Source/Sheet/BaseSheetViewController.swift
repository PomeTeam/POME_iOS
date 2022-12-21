//
//  SheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class BaseSheetViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    //MARK: - Properties
    
    var type: SheetType!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        style()
        layout()
        initialize()
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let controller: UISheetPresentationController = .init(presentedViewController: presented, presenting: presenting)
        
        let constant = getDetentSize()
        
        let detent: UISheetPresentationController.Detent = ._detent(withIdentifier: "Detent1", constant: constant)//type.rawValue * Const.Device.HEIGHT / 812
    
        controller.detents = [detent]
        controller.preferredCornerRadius = 16
        controller.prefersGrabberVisible = false
        
        return controller
    }
    
    func style(){
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func initialize() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    func layout() {}
    
    func setBottomSheetStyle(type: SheetType){
        self.type = type
    }
    
    private func getDetentSize() -> CGFloat{
        switch type{
        case .calendar:
            return type.rawValue + CalendarSheetCollectionViewCell.cellSize * 7
        case .category:
            return Const.Device.HEIGHT - type.rawValue
        default:
            return type.rawValue
        }
    }

}
