//
//  SheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class BaseSheetViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    //MARK: - Properties
    
    private final let type: SheetType!
    private var viewController: UIViewController?
    private var dimmedView = UIView().then{
        $0.backgroundColor = Color.popUpBackground
    }
    
    init(type: SheetType){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        controller.containerView?.backgroundColor = Color.popUpBackground

        
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
    
    final private func getDetentSize() -> CGFloat{
        switch type{
        case .calendar:
            return type.rawValue + CalendarSheetCollectionViewCell.cellSize * 7
        case .category:
            return Device.HEIGHT - type.rawValue
        default:
            return type.rawValue
        }
    }
    
    @discardableResult
    func loadAndShowBottomSheet(in viewController: UIViewController) -> Self{
        self.loadViewIfNeeded()
        self.viewController = viewController
        viewController.present(self, animated: true)
        return self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(viewController == nil){
            return
        }
        viewController?.view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dimmedView.removeFromSuperview()
    }
}
