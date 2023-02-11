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
    // 개인정보 처리방침 및 서비스 이용약관
    case privacyAndServiceUse = "https://few-horse-2aa.notion.site/6a2e6f6241e94a479a3e2c2a3cdb909e"
    // 서비스 이용 약관
    case serviceUse = "https://few-horse-2aa.notion.site/c646f930ac5a40a1b519471b940d203a"
    // 개인 정보 수집 동의
    case privacyTerm = "https://few-horse-2aa.notion.site/b396b02d8bd3460f945cf3f90935667b"
    // 마케팅 정보 활용 동의
    case marketingTerm = "https://few-horse-2aa.notion.site/8cc486236d77473f84fa53a3b0ede726"
    // 문의 양식
    case contact = "https://forms.gle/SaFj5Mi9Gq1yLGff9"
    // 신고 양식
    case report = "https://forms.gle/NhQ55kbYdkxnNseq7"
    // 인증번호 오류
    case codeError = "https://few-horse-2aa.notion.site/3b12466e1ff14690b5c2d05c273fb2cf"
    
    //TODO: 오픈소스 라이센스
    case openSourceLicense = ""
}

class LinkManager {
    var viewcontroller: UIViewController?
    
    init(_ vc: UIViewController, _ link: Link) {
        self.viewcontroller = vc
        
        guard let url = NSURL(string: link.rawValue) else {return}
        let linkView: SFSafariViewController = SFSafariViewController(url: url as URL)
        self.viewcontroller?.present(linkView, animated: true, completion: nil)
    }
    
    // urlStr로 이동하는 메서드
    func linkTo(_ urlStr: String) {
        guard let url = NSURL(string: urlStr) else {return}
        let linkView: SFSafariViewController = SFSafariViewController(url: url as URL)
        self.viewcontroller?.present(linkView, animated: true, completion: nil)
    }
}
