//
//  LinkManager.swift
//  POME
//
//  Created by gomin on 2023/02/05.
//

import Foundation
import UIKit
import SafariServices

enum Link: String {
    case serviceUse = "https://few-horse-2aa.notion.site/0bb91905ab734733a8baddfa5d459e07"
    case privacyTerm = "https://few-horse-2aa.notion.site/8d8b53bcae774895bb080abaa9b15319"
    case privacyUse = "https://few-horse-2aa.notion.site/1f71b0a5adac4b1ea1d8d7d0c1405ccc"
    case marketingTerm = "https://few-horse-2aa.notion.site/695cc52385ed427591768bb20b2053af"
    case contact = "https://forms.gle/SaFj5Mi9Gq1yLGff9"
    case report = "https://forms.gle/NhQ55kbYdkxnNseq7"
}

class LinkManager {
    var viewcontroller: UIViewController?
    
    init(_ vc: UIViewController, _ link: Link) {
        self.viewcontroller = vc
        
        guard let url = NSURL(string: link.rawValue) else {return}
        let linkView: SFSafariViewController = SFSafariViewController(url: url as URL)
        self.viewcontroller?.present(linkView, animated: true, completion: nil)
    }
    
    func linkTo(_ urlStr: String) {
        guard let url = NSURL(string: urlStr) else {return}
        let linkView: SFSafariViewController = SFSafariViewController(url: url as URL)
        self.viewcontroller?.present(linkView, animated: true, completion: nil)
    }
}
