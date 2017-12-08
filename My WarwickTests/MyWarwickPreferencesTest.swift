//
//  MyWarwickPreferencesTest.swift
//  My WarwickTests
//
//  Created by Kai Lan on 08/12/2017.
//  Copyright © 2017 University of Warwick. All rights reserved.
//

import XCTest
import CoreData

class MyWarwickPreferencesTest: XCTestCase {
    
    
    var preferences: MyWarwickPreferences!
    
    override func setUp() {
        super.setUp()
        preferences = MyWarwickPreferences(userDefaults: UserDefaults.standard)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTimetableNotificationShouldBeEnabledByDefault() {
        XCTAssert(preferences.timetableNotificationsEnabled == true)
    }
    
    func testTimeTableNotificationShouldBeDisabledIfUserPreviouslySetTheValueOfTheOldKeyToTrue() {
        
        let oldPref = UserDefaults.standard
        let oldKey = "TimetableNotificationsDisabled"
        oldPref.set(true, forKey: oldKey)
        preferences = MyWarwickPreferences(userDefaults: oldPref)
    
        XCTAssert(preferences.timetableNotificationsEnabled == false)
    
    }
    
    func testTimeTableNotificationShouldBeEnabledIfUserPreviouslySetTheValueOfTheOldKeyToFalse() {
        let oldPref = UserDefaults.standard
        let oldKey = "TimetableNotificationsDisabled"
        oldPref.set(false, forKey: oldKey)
        preferences = MyWarwickPreferences(userDefaults: oldPref)
        
        XCTAssert(preferences.timetableNotificationsEnabled == true)
    }

    func testTheOldKeyShouldBeRemovedAfterAccessValueOfTheNewKey() {

        let oldPref = UserDefaults.standard
        let oldKey = "TimetableNotificationsDisabled"
        oldPref.set(true, forKey: oldKey)
        preferences = MyWarwickPreferences(userDefaults: oldPref)
        
        XCTAssert(preferences.timetableNotificationsEnabled == false)
        XCTAssert(oldPref.object(forKey: oldKey) == nil)
    }
    

}
