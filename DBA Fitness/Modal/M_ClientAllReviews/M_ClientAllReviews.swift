
import Foundation

// MARK: - M_ClientAllReviews
struct M_ClientAllReviews: Codable {
    let status: Int
    let message: String
    let data: [M_ClientAllReviewsData]?
    let pages, currentPage: Int
    let method: String

    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method
    }
}

// MARK: - M_ClientAllReviewsData
struct M_ClientAllReviewsData: Codable {
    let rating, id, trainerID, userid, createdon: String?
    let name, image, comment: String?

    enum CodingKeys: String, CodingKey {
        case rating, id
        case trainerID = "trainer_id"
        case userid, createdon, name, image, comment
    }
}
