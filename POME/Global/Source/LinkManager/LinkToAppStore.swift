//
//  LinkToAppStore.swift
//  POME
//
//  Created by gomin on 2023/03/04.
//

import Foundation

enum AppstoreOpenError: Error {
    case invalidAppStoreURL
    case cantOpenAppStoreURL
}

class LinkToAppStore {
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/1672584491"
    let viewcontroller: UIViewController!
    
    init(_ viewcontroller: UIViewController) {
        self.viewcontroller = viewcontroller
        
        openAppStore(urlStr: LinkToAppStore.appStoreOpenUrlString)
    }
    
    func openAppStore(urlStr: String) -> Result<Void, AppstoreOpenError> {
        guard let url = URL(string: urlStr) else {
            print("invalid app store url")
            return .failure(.invalidAppStoreURL)
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return .success(())
        } else {
            let dialog = TextInfoPopUpViewController(titleText: "앱스토어를 설치해주세요.", greenBtnText: "확인")
            dialog.modalPresentationStyle = .overFullScreen
            self.viewcontroller.present(dialog, animated: false, completion: nil)
            
            print("can't open app store url")
            return .failure(.cantOpenAppStoreURL)
        }
    }
}
