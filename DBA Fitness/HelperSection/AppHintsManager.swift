import Foundation
import SwiftUI

final class AppHintsManager {
    
    // Singleton instance
    static let shared = AppHintsManager()

    // AppStorage-backed property (only works in SwiftUI views)
    // So we fall back to UserDefaults for UIKit usage
    private let key = "hasShownGoalSwipeHint"

    var hasShownGoalSwipeHint: Bool {
        get {
            UserDefaults.standard.bool(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }

    private init() {}
}
