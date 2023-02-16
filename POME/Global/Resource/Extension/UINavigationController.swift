//
//  UINavigationController.swift
//  POME
//
//  Created by 박소윤 on 2023/02/16.
//

import Foundation

extension UINavigationController{
    
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        
        popViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
