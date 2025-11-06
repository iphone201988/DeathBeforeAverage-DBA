
import Foundation

// MARK: - M_SendMessages
struct M_SendMessages: Codable {
    let status: Int
    let message: String
    let data: [M_SendMessagesData]?
    let method: String
}

// MARK: - M_SendMessagesData
struct M_SendMessagesData: Codable {
    let id, senderID, reciverID, type: String?
    let message, image, isactive, isread: String?
    let createdOn, senderName, recieverName, video: String?

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case reciverID = "reciver_id"
        case type, message, image, isactive, isread
        case createdOn = "created_on"
        case senderName = "sender_name"
        case recieverName = "reciever_name"
        case video
    }
}
