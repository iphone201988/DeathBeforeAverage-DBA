
import Foundation

// MARK: - M_CardInfo
struct M_CardInfo: Codable {
    let status: Int
    let message: String
    let data: [M_CardData]?
    let method: String
}

// MARK: - M_CardData
struct M_CardData: Codable {
    let cardid, tokenid, userid, holdername: String?
    let expYear, expMonth, card, isdeafult, full_card: String?
    let cansave, status: String?

    enum CodingKeys: String, CodingKey {
        case cardid, tokenid, userid, holdername
        case expYear = "exp_year"
        case expMonth = "exp_month"
        case full_card = "full_card"
        case card, isdeafult, cansave, status
    }
}

struct CheckUsernameResponse: Codable {
    let status: Int
    let message: String
    let method: String
}
