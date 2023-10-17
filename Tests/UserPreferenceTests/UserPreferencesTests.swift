//
//  UserPreferencesTests.swift
//  
//  
//  Created by keiji0 on 2022/05/07
//  
//

import XCTest
import Combine
import AppToolsData
@testable import AppToolsUserPreference

final class UserPreferencesTests: XCTestCase {
    override func setUp() {
        super.setUp()
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }

    override class func tearDown() {
    }
    
    func test_値を設定して取得できる() {
        class Preference: UserPreferenceBase {
            @UserPreferenceValue("v1", defaultValue: 999)
            var v1: Int
        }
        let preference = Preference()
        XCTAssertEqual(preference.v1, 999)
        
        preference.v1 = 5
        XCTAssertEqual(preference.v1, 5)
    }
    
    func test_他のカテゴリに影響はない() {
        class PreferenceA: UserPreferenceBase {
            let category = Category("a")
            @UserPreferenceValue("v1", defaultValue: 999)
            var v1: Int
        }
        class PreferenceB: UserPreferenceBase {
            let category = Category("b")
            @UserPreferenceValue("v1", defaultValue: 999)
            var v1: Int
        }
        
        let preferenceA = PreferenceA()
        let preferenceB = PreferenceB()
        
        preferenceA.v1 = 1
        XCTAssertEqual(preferenceB.v1, 999)
    }
    
    fileprivate static var userStore: any KeyValueStorable {
        UserDefaults.standard
    }
}

private protocol UserPreferenceBase: UserPreferences {
}

extension UserPreferenceBase {
    var store: KeyValueStorable { UserDefaults.standard }
}
