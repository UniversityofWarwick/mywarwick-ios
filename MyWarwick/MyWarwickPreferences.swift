import Foundation

class MyWarwickPreferences {

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        setDefaultValue()
    }
    
    func setDefaultValue() {
        let oldKey = "TimetableNotificationsDisabled"
        let newKey = "TimetableNotificationsEnabled"
        
        if UserDefaults.standard.object(forKey: oldKey) == nil {
            if UserDefaults.standard.object(forKey: newKey) == nil {
                userDefaults.set(true, forKey: newKey)
            }
        } else {
            userDefaults.set(!userDefaults.bool(forKey: oldKey), forKey: newKey)
            userDefaults.removeObject(forKey: oldKey)
        }
        
        if UserDefaults.standard.object(forKey: "TimetableNotificationsSoundEnabled") == nil {
            userDefaults.set(true, forKey: "TimetableNotificationsSoundEnabled")
        }
    }

    var canWorkOffline: Bool {
        get {
            return userDefaults.bool(forKey: "AppCached")
        }

        set(cached) {
            userDefaults.set(cached, forKey: "AppCached")
            userDefaults.synchronize()
        }
    }

    var deviceToken: String? {
        get {
            return userDefaults.string(forKey: "DeviceToken")
        }

        set(token) {
            userDefaults.set(token, forKey: "DeviceToken")
            userDefaults.synchronize()
        }
    }
    
    var chosenBackgroundId: Int? {
        get {
            return userDefaults.integer(forKey: "ChosenBackgroundId")
        }
        
        set(bgId) {
            userDefaults.set(bgId, forKey: "ChosenBackgroundId")
            userDefaults.synchronize()
        }
    }
    
    var chosenHighContrast: Bool? {
        get {
            return userDefaults.bool(forKey: "ChosenHighContrast")
        }
        
        set(isHighContrast) {
            userDefaults.set(isHighContrast, forKey: "ChosenHighContrast")
            userDefaults.synchronize()
        }
    }

    var timetableToken: String? {
        get {
            return userDefaults.string(forKey: "TimetableToken")
        }

        set(token) {
            userDefaults.set(token, forKey: "TimetableToken")
            userDefaults.set(false, forKey: "NeedsTimetableTokenRefresh")
            userDefaults.synchronize()

            if token != nil {
                Global.backgroundQueue.async {
                    let dataController = DataController()
                    dataController.load {
                        EventFetcher(dataController: dataController, preferences: self).updateEvents() { (success) in
                        }
                    }
                }
            }
        }
    }

    var timetableNotificationsEnabled: Bool {
        get {
            return userDefaults.bool(forKey: "TimetableNotificationsEnabled")
        }
        set(enabled) {
            if (enabled != timetableNotificationsEnabled) {
                userDefaults.set(enabled, forKey: "TimetableNotificationsEnabled")
                userDefaults.synchronize()
                Global.backgroundQueue.async {
                    let dataController = DataController()
                    dataController.load {
                        NotificationScheduler(dataController: dataController, preferences: self).rescheduleAllNotifications()
                    }
                }
            }
        }
    }

    var timetableNotificationTiming: Int {
        get {
            if let timing = userDefaults.object(forKey: "TimetableNotificationTiming") as! Int? {
                return timing
            }

            return 15
        }

        set(timing) {
            if (timing != timetableNotificationTiming) {
                userDefaults.set(timing, forKey: "TimetableNotificationTiming")
                userDefaults.synchronize()

                // this should not be possible throught the ui, but let's just be safe
                if (userDefaults.bool(forKey: "TimetableNotificationsEnabled")) {
                    Global.backgroundQueue.async {
                        let dataController = DataController()
                        dataController.load {
                            NotificationScheduler(dataController: dataController, preferences: self).rescheduleAllNotifications()
                        }
                    }
                }
                
            }
        }
    }
    
    var timetableNotificationsSoundEnabled: Bool {
        get {
            return userDefaults.bool(forKey: "TimetableNotificationsSoundEnabled")
        }
        set(enabled) {
            if (enabled != timetableNotificationsSoundEnabled) {
                userDefaults.set(enabled, forKey: "TimetableNotificationsSoundEnabled")
                userDefaults.synchronize()
            }
        }
    }

    var needsTimetableTokenRefresh: Bool {
        get {
            return userDefaults.bool(forKey: "NeedsTimetableTokenRefresh")
        }

        set(refresh) {
            userDefaults.set(refresh, forKey: "NeedsTimetableTokenRefresh")
            userDefaults.synchronize()
        }
    }
}
