
import Foundation

// MARK: - M_TrainerClientList
struct M_TrainerClientList: Codable {
    let status: Int
    let message: String
    let data: [M_TrainerClientData]?
    let pages, currentPage: Int
    let method: String

    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method
    }
}

// MARK: - M_TrainerClientData
struct M_TrainerClientData: Codable {
    let userid, firstname, lastname, email: String?
    let type, location, specialist, about: String?
    let password, image, height, competitive: String?
    let offSeason, age, sex, bodyFatPercentage: String?
    let neckSize, sholuderSize, bicepSize, chestSize: String?
    let forearmSize, waistSize, hipsSize, thighSize: String?
    let calfSize, tempPassword, sessionkey, token: String?
    let devicetype, devicetoken, createdon, isactive: String?
    let name, all_programs: String?

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
        case sessionkey, token, devicetype, devicetoken, createdon, isactive, name, all_programs
    }
}


// MARK: - MNotificationLists
struct MNotificationLists: Codable {
    let status: Int?
    let message: String?
    let data: [MNotificationListsDetails]?
    let method: String?
}

// MARK: - MNotificationListsDetails
struct MNotificationListsDetails: Codable {
    let id, type, fromUserid, userid: String?
    let title, specialID, isread, createdon: String?
    let name, image: String?
    let post_id: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case fromUserid = "from_userid"
        case userid, title
        case specialID = "special_id"
        case isread, createdon, name, image, post_id
    }
}
