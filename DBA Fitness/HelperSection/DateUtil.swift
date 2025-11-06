
import Foundation
import UIKit

class DateUtil {
    
    public static var dateFormatForRoomMatesAcitivities = "d MMM yyyy"
    public static var timeFormatForRoomMatesAcitivities = "hh:mm a"
    public static var dateFormatForAddTaskParams = "yyyy-MM-dd"
    public static var timeFormatForAddTaskParams = "HH:mm"
    public static var timeFormatForShowingRecentTask = "MMMM, yyyy"
    public static var dateTimeFormatForRecentTask = "yyyy-MM-dd HH:mm:s"
    public static var dateFormatForHistory = "d, MMMM yy"
    public static var dateFormatAccordinglyTwelveTimeFormat = "EE, dd-MMM-yyyy HH:mm a"
    public static var dateFormatAccordinglyTwentyFourTimeFormat = "EE, dd-MMM-yyyy HH:mm"
    
    public static let dateFormatter = DateFormatter()
    
    public static func convertDateIntoStringFormat(_ date:Date, _ dateFormat:String? = nil) -> String? {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    public static func convertTimeIntoStringFormat(_ date:Date, _ timeFormat:String? = nil) -> String? {
        dateFormatter.dateFormat = timeFormat
        return dateFormatter.string(from: date)
    }
    
    public static func utcDateTime(_ date: Date, _ timeFormat: String? = nil) -> String? {
        dateFormatter.timeZone = TimeZone(identifier: "UTC") //TimeZone(abbreviation: "UTC") - both are same
        dateFormatter.dateFormat = timeFormat
        return dateFormatter.string(from: date)
    }
    
    public static func convertUTCToLocalDateTime(_ date: Date, _ timeFormat: String? = nil) -> String? {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = timeFormat
        return dateFormatter.string(from: date)
    }
}

