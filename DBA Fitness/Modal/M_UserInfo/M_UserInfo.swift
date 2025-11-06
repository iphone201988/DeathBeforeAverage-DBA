/*
import Foundation

// MARK: - M_UserInfo
struct M_UserInfo: Codable {
    let status: Int
    let message: String
    let data: M_UserData?
    let goal: [M_UserGoal]?
    let achievement: [M_UserAchievement]?
    let method: String
}

// MARK: - Achievement
struct M_UserAchievement: Codable {
    let id, userid, year, event: String?
    let juniorAbsolute, menUpTo90_Kg: String?
    let image: [String]?
    let createdon: String?

    enum CodingKeys: String, CodingKey {
        case id, userid, year, event
        case juniorAbsolute = "junior_absolute"
        case menUpTo90_Kg = "men_up_to_90_kg"
        case image, createdon
    }
}

// MARK: - M_UserDetailsData
struct M_UserData: Codable {
    let userid, firstname, lastname, email: String?
    let type, location, specialist, about: String?
    let password, image, height, competitive: String?
    let offSeason, age, sex, bodyFatPercentage: String?
    let neckSize, sholuderSize, bicepSize, chestSize: String?
    let forearmSize, waistSize, hipsSize, thighSize: String?
    let calfSize, tempPassword, sessionkey, devicetype: String?
    let devicetoken, createdon, isactive, following: String?
    let follower, rating: String?
    let isfollow: Int

    enum CodingKeys: String, CodingKey {
        case userid, firstname, lastname, email, type, location, specialist, about, password, image, height, competitive
        case offSeason = "off_season"
        case age, sex
        case bodyFatPercentage = "body_fat_percentage"
        case neckSize = "neck_size"
        case sholuderSize = "sholuder_size"
        case bicepSize = "bicep_size"
        case chestSize = "chest_size"
        case forearmSize = "forearm_size"
        case waistSize = "waist_size"
        case hipsSize = "hips_size"
        case thighSize = "thigh_size"
        case calfSize = "calf_size"
        case tempPassword = "temp_password"
        case sessionkey, devicetype, devicetoken, createdon, isactive, following, follower, rating, isfollow
    }
}

// MARK: - M_UserGoal
struct M_UserGoal: Codable {
    let id, userid, title, goalDescription: String?
    let createdon: String?

    enum CodingKeys: String, CodingKey {
        case id, userid, title
        case goalDescription = "description"
        case createdon
    }
}
*/

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - M_UserInfo
struct M_UserInfo: Codable {
    let status: Int
    let message: String
    let data: M_UserData?
    let goal: [M_UserGoal]?
    let achievement: [M_UserAchievements]?
    let myGallery: [M_UserMyGallery]?
    let method: String
    
    enum CodingKeys: String, CodingKey {
        case status, message, data, goal, achievement
        case myGallery = "my_gallery"
        case method
    }
}

// MARK: - Achievement
struct M_UserAchievements: Codable {
    let id, userid, year, event: String?
    let juniorAbsolute, menUpTo90_Kg: String?
    let image: [String]?
    let createdon: String?

    enum CodingKeys: String, CodingKey {
        case id, userid, year, event
        case juniorAbsolute = "junior_absolute"
        case menUpTo90_Kg = "men_up_to_90_kg"
        case image, createdon
    }
}

// MARK: - DataClass
struct M_UserData: Codable {
    let userid, firstname, lastname, email: String?
    let type, location, specialist, about: String?
    let password, image, height, competitive: String?
    let offSeason, age, sex, bodyFatPercentage: String?
    let neckSize, sholuderSize, bicepSize, chestSize: String?
    let forearmSize, waistSize, hipsSize, thighSize: String?
    let calfSize, tempPassword, sessionkey, token: String?
    let devicetype, devicetoken, createdon, isactive: String?
    let totalReviews: Int?
    let rating, following, follower: String?
    let isfollow: Int?
    let dataPrivate: String?
    let notification_alert, is_purchased:String?
    let isrequest:String?
    let is_apple, is_google, is_facebook, username, is_rating_enable:String?
    let no_of_requests:Int?
    let is_connected_stripe: String?

    enum CodingKeys: String, CodingKey {
        case userid, firstname, lastname, email, type, location, specialist, about, password, image, height, competitive
        case offSeason = "off_season"
        case age, sex
        case bodyFatPercentage = "body_fat_percentage"
        case neckSize = "neck_size"
        case sholuderSize = "sholuder_size"
        case bicepSize = "bicep_size"
        case chestSize = "chest_size"
        case forearmSize = "forearm_size"
        case waistSize = "waist_size"
        case hipsSize = "hips_size"
        case thighSize = "thigh_size"
        case calfSize = "calf_size"
        case tempPassword = "temp_password"
        case sessionkey, token, devicetype, devicetoken, createdon, isactive
        case totalReviews = "total_reviews"
        case rating, following, follower, isfollow
        case dataPrivate = "private"
        case notification_alert, is_purchased
        case isrequest
        case is_apple, is_google, is_facebook, username, is_rating_enable
        case no_of_requests
        case is_connected_stripe
    }
}

// MARK: - M_UserGoal
struct M_UserGoal: Codable {
    let id, userid, title, goalDescription: String?
    let createdon: String?
    let image:[String]?
    let video:[String]?
    let type:String?
    let thumbnil:[String]?

    enum CodingKeys: String, CodingKey {
        case id, userid, title
        case goalDescription = "description"
        case createdon,image,video,type,thumbnil
    }
}

// MARK: - M_UserMyGallery
//struct M_UserMyGallery: Codable {
//    let id, userid, image, createdon, post_id, description: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, userid, image, createdon, post_id, description
//
//    }
//}

// MARK: - MyGallery
struct M_UserMyGallery: Codable {
    let id, userid, post_id, image ,video , upload_type: String?
    let createdon, myGalleryDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, userid, post_id
        case image, createdon
        case myGalleryDescription = "description"
        case video
        case upload_type
    }
}


// MARK: - Welcome
struct FollowerANDFollowingUserInfo: Codable {
    let status: Int
    let message: String?
    let data: [M_UserData]?
    let pages, currentPage: Int?
    let method, createdon: String?

    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method, createdon
    }
}
