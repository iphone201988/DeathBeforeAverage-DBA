
import Foundation

// MARK: - M_ProgramTranining
struct M_ProgramTranining: Codable {
    let status: Int
    let message: String
    let data: [M_ProgramTraniningData]?
    let pages, currentPage: Int
    let method: String

    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method
    }
}

// MARK: - M_ProgramTraniningData
struct M_ProgramTraniningData: Codable {
    let id, programID, trainingName, trainingDay: String?
    let trainingVideo, trainingDescription, createdon: String?
    let thumbnil:String?
    let training_thumbnil:String?

    enum CodingKeys: String, CodingKey {
        case id
        case programID = "program_id"
        case trainingName = "training_name"
        case trainingDay = "training_day"
        case trainingVideo = "training_video"
        case trainingDescription = "training_description"
        case createdon, thumbnil, training_thumbnil
    }
}
