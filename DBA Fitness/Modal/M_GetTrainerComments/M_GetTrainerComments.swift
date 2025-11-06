
import Foundation

// MARK: - M_GetTrainerComments
struct M_GetTrainerComments: Codable {
    let status: Int
    let message: String
    let data: [M_GetTrainerCommentsData]?
    let rating, method: String
}

// MARK: - M_GetTrainerCommentsData
struct M_GetTrainerCommentsData: Codable {
    let userid, comment, commentID, name, createdon: String?
    let userImage, image: String?

    enum CodingKeys: String, CodingKey {
        case userid, comment
        case commentID = "comment_id"
        case name, createdon
        case userImage = "user_image"
        case image
    }
}
