
import Foundation

// MARK: - M_isFollow
struct M_isFollow: Codable {
    let status: Int
    let message: String
    let data: M_isFollowInfo?
    let method: String
}

// MARK: - M_isFollowInfo
struct M_isFollowInfo: Codable {
    let userid, totalFollower, totalFollowing: String?
    let isfollow: Int?

    enum CodingKeys: String, CodingKey {
        case userid
        case totalFollower = "total_follower"
        case totalFollowing = "total_following"
        case isfollow
    }
}
