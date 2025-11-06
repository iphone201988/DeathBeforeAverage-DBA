
import Foundation

// MARK: - M_AllPosts
struct M_AllPosts: Codable {
    let status: Int
    let message: String
    let data: [M_AllPostsData]?
    let pages, currentPage: Int?
    let method: String
    
    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method
    }
}

// MARK: - M_AllPostsData
struct M_AllPostsData: Codable {
    let userid, name, userImage, postID: String?
    let datumDescription, image, video, postDate, totalLike, islike: String?
    let totalComments: String?
    let firstname: String?
    let lastname: String?
    
    enum CodingKeys: String, CodingKey {
        case userid, name
        case userImage = "user_image"
        case postID = "post_id"
        case datumDescription = "description"
        case image
        case postDate = "post_date"
        case totalLike = "total_like"
        case islike
        case totalComments = "total_comments"
        case firstname, lastname
        case video
    }
}
