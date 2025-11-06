
import Foundation

// MARK: - M_GetAllTrainer
struct M_GetAllTrainer: Codable {
    let status: Int
    let message: String
    let data: [M_GetAllTrainerData]?
    let pages, currentPage: Int
    let method: String

    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method
    }
}

// MARK: - M_GetAllTrainerData
struct M_GetAllTrainerData: Codable {
    let userid, firstname, lastname, email: String?
    let type, location, specialist, about: String?
    let password, image, height, competitive: String?
    let offSeason, age, sex, bodyFatPercentage: String?
    let neckSize, sholuderSize, bicepSize, chestSize: String?
    let forearmSize, waistSize, hipsSize, thighSize: String?
    let calfSize, tempPassword, sessionkey, devicetype: String?
    let devicetoken, createdon, isactive: String?
    let certificateImage: [String]?
    let rating: String?
    let isPurchased, is_rating_enable:String?
    let achievements : [M_UserAchievements]?

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
        case sessionkey, devicetype, devicetoken, createdon, isactive
        case certificateImage = "certificate_image"
        case rating
        case isPurchased, is_rating_enable
        case achievements
    }
}
