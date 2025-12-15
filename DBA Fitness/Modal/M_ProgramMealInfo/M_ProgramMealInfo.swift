
import Foundation

// MARK: - M_ProgramMealInfo
struct M_ProgramMealInfo: Codable {
    let status: Int?
    let message: String?
    let data: [M_ProgramMealData]?
    let method: String?
}

// MARK: - M_ProgramMealData
struct M_ProgramMealData: Codable {
    let id, dayID, programID, mealDay: String?
    let mealTitle, mealDescription, createdon: String?

    enum CodingKeys: String, CodingKey {
        case id
        case dayID = "day_id"
        case programID = "program_id"
        case mealDay = "meal_day"
        case mealTitle = "meal_title"
        case mealDescription = "meal_description"
        case createdon
    }
}
