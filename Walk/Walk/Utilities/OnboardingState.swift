import Foundation

enum OnboardingState {
    private static let hasSeenKey = "hasSeenOnboarding"

    static var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: hasSeenKey)
    }

    static func markOnboardingSeen() {
        UserDefaults.standard.set(true, forKey: hasSeenKey)
    }
}
