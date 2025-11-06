
import Foundation

// MARK: - M_GetPostComments
struct M_GetPostComments: Codable {
    let status: Int
    let message: String
    let data: [M_GetPostCommentsData]?
    let method: String
}

// MARK: - Datum
struct M_GetPostCommentsData: Codable {
    let userid: String?
    let name: String?
    let userImage: String?
    let commentID: String?
    let comment: String?
    let postID: String?
    let createdon: String?
    
    enum CodingKeys: String, CodingKey {
        case userid, name
        case userImage = "user_image"
        case commentID = "comment_id"
        case comment = "comment"
        case postID = "post_id"
        case createdon
    }
}

