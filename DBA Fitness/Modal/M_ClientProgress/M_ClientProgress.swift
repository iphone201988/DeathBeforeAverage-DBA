
import Foundation

// MARK: - M_ClientProgress
struct M_ClientProgress: Codable {
    let status: Int
    let message: String
    let data: [M_ClientProgressData]?
    let pages, currentPage: Int
    let method: String

    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method
    }
}

// MARK: - M_ClientProgressData
struct M_ClientProgressData: Codable {
    let id, userid: String?
    var image: [String]?
    let datumDescription, createdon: String?

    enum CodingKeys: String, CodingKey {
        case id, userid, image
        case datumDescription = "description"
        case createdon
    }
}
