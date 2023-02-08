//
//  HTTPMethodURL.swift
//  POME
//
//  Created by 박소윤 on 2023/01/25.
//

import Foundation

enum HTTPMethodURL {
    
    static let recordsURL = "/records"
    static let goalsURL = "/goals"
    static let userURL = "/users"
    static let friendURL = "/users/friend"
    static let goalCategoryURL = "/goal-category"
    
    struct GET {
        static let records = HTTPMethodURL.recordsURL
        static let recordOfGoal = HTTPMethodURL.recordsURL + "/goal" //기록 페이징 조회
        static let recordOfFriend = HTTPMethodURL.recordsURL + "/users" //기록 페이징 조회
        static let recordsOfAllFriend = HTTPMethodURL.recordsURL + "/friends" //기록 페이징 조회
        
        static let goal = HTTPMethodURL.goalsURL
        static let pageOfGoalCategory = HTTPMethodURL.goalsURL + "/category"
        
        static let friendSearch = HTTPMethodURL.friendURL
        static let friends = HTTPMethodURL.userURL + "/friends"
        
        static let goalCategory = HTTPMethodURL.goalCategoryURL
        static let goals = HTTPMethodURL.goalsURL + "/users"
        static let finishedGoals = HTTPMethodURL.goalsURL + "/users/end"
        
        static let noSecondEmotionRecords = HTTPMethodURL.recordsURL + "/one-week/goal"
    }
    
    struct POST {
        static let record = HTTPMethodURL.recordsURL
        static let secondEmotion = HTTPMethodURL.recordsURL
        static let friendEmotion = HTTPMethodURL.recordsURL
        
        static let goal = HTTPMethodURL.goalsURL
        
        static let signUp = HTTPMethodURL.userURL + "/sign-up"
        static let signIn = HTTPMethodURL.userURL + "/sign-in"
        static let logout = HTTPMethodURL.userURL + "/logout"
        static let friend = HTTPMethodURL.friendURL
        static let nicknameDuplicate = HTTPMethodURL.userURL + "/check-nickname"
        static let sms = "/sms/send"
        static let checkUser = HTTPMethodURL.userURL
        
        static let goalCategory = HTTPMethodURL.goalCategoryURL
        
        static let authRenew = "/auth/renew"
    }
    
    struct PUT {
        static let record = HTTPMethodURL.recordsURL
        static let goal = HTTPMethodURL.goalsURL
        static let finishGoal = HTTPMethodURL.goalsURL + "/end"
    }
    
    struct DELETE {
        static let record = HTTPMethodURL.recordsURL
        static let goal = HTTPMethodURL.goalsURL
        static let friend = HTTPMethodURL.friendURL
        static let goalCategory = HTTPMethodURL.goalCategoryURL
        static let deleteUser = HTTPMethodURL.userURL
    }
    
    
}
