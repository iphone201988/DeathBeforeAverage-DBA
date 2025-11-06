
import Foundation

// MARK: - M_CatalogueInfo
struct M_CatalogueInfo: Codable {
    let status: Int
    let message: String?
    let data: [M_CatalogueData]?
    let pages, currentPage: Int?
    let method: String?

    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method
    }
}

// MARK: - M_CatalogueData
struct M_CatalogueData: Codable {
    let id, userid, title, createdon, sets, reps, time: String?
}
