import UIKit
import Foundation

// MARK: - M_ExerciseDetails
struct M_ExerciseDetails: Codable {
    let status: Int
    let message: String?
    var data: [M_ExerciseData]?
    let pages, currentPage: Int?
    let method: String?
    
    enum CodingKeys: String, CodingKey {
        case status, message, data, pages
        case currentPage = "current_page"
        case method
    }
}

// MARK: - M_ExerciseData
struct M_ExerciseData: Codable {
    let id, userid, excerciseName, excerciseDescription: String?
    let excerciseImage: [String]?
    let excerciseVideo, createdon: String?
    let thumbnil:String?
    let type:String?
    let folder_id, folder_name, program_id, training_id, videoUrl, exercise_info, sets, reps, time: String?
    let e_id, is_catalogue, is_active: String?
    let is_flag: String?
    let position: String?
    
    enum CodingKeys: String, CodingKey {
        case id, userid
        case excerciseName = "excercise_name"
        case excerciseDescription = "excercise_description"
        case excerciseImage = "excercise_image"
        case excerciseVideo = "excercise_video"
        case createdon, thumbnil, type, folder_id, folder_name, program_id, training_id, videoUrl, exercise_info, sets, reps, time
        case e_id, is_catalogue, is_active, is_flag, position
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String.self, forKey: .id)
        userid = try? container.decode(String.self, forKey: .userid)
        excerciseName = try? container.decode(String.self, forKey: .excerciseName)
        excerciseDescription = try? container.decode(String.self, forKey: .excerciseDescription)
        excerciseImage = try? container.decode([String].self, forKey: .excerciseImage)
        excerciseVideo = try? container.decode(String.self, forKey: .excerciseVideo)
        createdon = try? container.decode(String.self, forKey: .createdon)
        thumbnil = try? container.decode(String.self, forKey: .thumbnil)
        type = try? container.decode(String.self, forKey: .type)
        folder_id = try? container.decode(String.self, forKey: .folder_id)
        folder_name = try? container.decode(String.self, forKey: .folder_name)
        program_id = try? container.decode(String.self, forKey: .program_id)
        training_id = try? container.decode(String.self, forKey: .training_id)
        videoUrl = try? container.decode(String.self, forKey: .videoUrl)
        exercise_info = try? container.decode(String.self, forKey: .exercise_info)
        sets = try? container.decode(String.self, forKey: .sets)
        reps = try? container.decode(String.self, forKey: .reps)
        time = try? container.decode(String.self, forKey: .time)
        e_id = try? container.decode(String.self, forKey: .e_id)
        is_catalogue = try? container.decode(String.self, forKey: .is_catalogue)
        is_active = try? container.decode(String.self, forKey: .is_active)
        
        // Custom decoding for `is_flag` which can be either a String or an Int
        if let stringValue = try? container.decode(String.self, forKey: .is_flag) {
            is_flag = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .is_flag) {
            is_flag = String(intValue)
        } else {
            is_flag = nil
        }
        
        // Custom decoding for `position` which can be either a String or an Int
        if let stringValue = try? container.decode(String.self, forKey: .position) {
            position = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .position) {
            position = String(intValue)
        } else {
            position = nil
        }
    }
}
