//
//  GoalBannerStyle.swift
//  POME
//
//  Created by 박소윤 on 2023/05/19.
//

import Foundation

protocol GoalBannerStyle{
    var title: String { get }
    var btnTitle: String { get }
    var bannerImage: UIImage { get }
    var btnColor: UIColor { get }
}

struct GoalRegisterInRecord: GoalBannerStyle{
    let title: String = "목표를 세워 친구와\n마시멜로를 모아보세요!"
    let btnTitle: String = "목표 만들기 >"
    let bannerImage: UIImage = Image.mintMarshmallow
    let btnColor: UIColor = Color.mint100
}

struct GoalRegisterInReview: GoalBannerStyle{
    let title: String = "목표가 있어야 씀씀이를\n기록하고 돌아볼 수 있어요"
    let btnTitle: String = "목표 만들기 >"
    let bannerImage: UIImage = Image.flagMint
    let btnColor: UIColor = Color.mint100
}

struct FinishGoal: GoalBannerStyle{
    let title: String = "목표가 종료되었어요!\n지난 기록들을 확인해보세요"
    let btnTitle: String = "목표 종료하기 >"
    let bannerImage: UIImage = Image.flagPink
    let btnColor: UIColor = Color.pink100
}
