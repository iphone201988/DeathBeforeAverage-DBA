import Foundation

// MARK: - M_ProgramDetails
struct M_ProgramDetails: Codable {
    let status: Int?
    let message: String?
    var data: [M_ProgramData]?
    let pages, currentPage: Int?
    let method: String?
    let is_connected_stripe:String?
    
    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method
        case is_connected_stripe
    }
}

// MARK: - M_ProgramData
struct M_ProgramData: Codable {
    let id, userid, programName, programDescription: String?
    let levelOfTraining, goals, price, category: String?
    let sex, daysPerWeek, suppliment, createdon, image, email: String?
    let isPurchased: String?
    let stripe_secret_key: String?

    enum CodingKeys: String, CodingKey {
        case id, userid
        case programName = "program_name"
        case programDescription = "program_description"
        case levelOfTraining = "level_of_training"
        case goals, price, category, sex
        case daysPerWeek = "days_per_week"
        case suppliment, createdon, image, email
        case isPurchased, stripe_secret_key
    }
}
