/*
import Foundation

// MARK: - M_UserDetails
struct M_UserDetails: Codable {
    let status: Int
    let message: String
    let data: M_UserDetailsData?
    let goal: [M_UserDetailsGoal]?
    let achievement: [M_UserDetailsAchievement]?
    let method: String
}

// MARK: - Achievement
struct M_UserDetailsAchievement: Codable {
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
struct M_UserDetailsData: Codable {
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
struct M_UserDetailsGoal: Codable {
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

// MARK: - M_UserDetails
struct M_UserDetails: Codable {
    let status: Int
    let message: String
    let data: M_UserDetailsData?
    let goal: [M_UserDetailsGoal]?
    let achievement: [M_UserDetailsAchievement]?
    let method: String
}

// MARK: - Achievement
struct M_UserDetailsAchievement: Codable {
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
struct M_UserDetailsData: Codable {
    let userid, firstname, lastname, email: String?
    let type, location, specialist, about: String?
    let password, image, height, competitive: String?
    let offSeason, age, sex, bodyFatPercentage: String?
    let neckSize, sholuderSize, bicepSize, chestSize: String?
    let forearmSize, waistSize, hipsSize, thighSize: String?
    let calfSize, tempPassword, sessionkey, token: String?
    let devicetype, devicetoken, createdon, isactive: String?
    let totalReviews: String?
    let rating, following, follower: String?
    let isfollow: Int?

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
    }
}

// MARK: - M_UserGoal
struct M_UserDetailsGoal: Codable {
    let id, userid, title, goalDescription: String?
    let createdon: String?

    enum CodingKeys: String, CodingKey {
        case id, userid, title
        case goalDescription = "description"
        case createdon
    }
}
