import Foundation

class Config {

    static let defaultAppURL = URL(string: "https://my.warwick.ac.uk")!

    static let webSignOnURL = URL(string: "https://websignon.warwick.ac.uk")!

    static var shortVersionString: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static var bundleVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String

    static var applicationNameForUserAgent: String {
        return "MyWarwick/\(shortVersionString)"
    }

    static var appURL: URL {
        let defaults = UserDefaults.standard

        if let deployment = defaults.string(forKey: "MyWarwickDeployment") {
            if deployment == "custom" {
                if let customDeployment = defaults.string(forKey: "MyWarwickCustomDeployment") {
                    if let url = URL(string: customDeployment) {
                        print("Custom deployment URL: \(url)")
                        return url
                    } else {
                        print("Invalid custom deployment URL: \(customDeployment)")
                    }
                }
            }

            print("Configured standard deployment \(deployment)")
            return URL(string: "https://\(deployment).warwick.ac.uk")!
        }

        return defaultAppURL
    }

}
