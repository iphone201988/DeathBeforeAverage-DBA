
import Foundation

// MARK: - M_GetMessages
struct M_GetMessages: Codable {
    let status: Int
    let message: String
    let data: [M_GetMessagesData]?
    let method: String
}

// MARK: - M_GetMessagesData
struct M_GetMessagesData: Codable {
    let senderID, message, createdOn, messageID: String?
    let senderName, image: String?
    let messageCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case senderID = "sender_id"
        case messageCount = "message_count"
        case message
        case createdOn = "created_on"
        case messageID = "id"
        case senderName = "sender_name"
        case image
    }
}

