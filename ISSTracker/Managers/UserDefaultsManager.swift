//
//  UserDefaultsManager.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/21/21.
//

import Foundation

enum UserDefaultsManager {
    static var appearance: Int {
        get { return appearanceInfo.get() }
        set { appearanceInfo.set(newValue) }
    }
    private static var appearanceInfo = UserDefaultInfo(key: "appearance", defaultValue: 0)

    static var largeMapAnnotations: Bool {
        get { return largeMapAnnotationsInfo.get() }
        set { largeMapAnnotationsInfo.set(newValue) }
    }
    private static var largeMapAnnotationsInfo = UserDefaultInfo(key: "largeMapAnnotations", defaultValue: false)

    static var defaultMapType: Int {
        get { return defaultMapTypeInfo.get() }
        set { defaultMapTypeInfo.set(newValue) }
    }
    private static var defaultMapTypeInfo = UserDefaultInfo(key: "defaultMapType", defaultValue: 0)

    static var numberOfImageColumns: Int {
        get { return numberOfImageColumnsInfo.get() }
        set { numberOfImageColumnsInfo.set(newValue) }
    }
    private static var numberOfImageColumnsInfo = UserDefaultInfo(key: "numberOfImageColumns", defaultValue: 2)

    static var reduceAnimations: Bool {
        get { return reduceAnimationsInfo.get() }
        set { reduceAnimationsInfo.set(newValue) }
    }
    private static var reduceAnimationsInfo = UserDefaultInfo(key: "reduceAnimations", defaultValue: false)

    static var haptics: Bool {
        get { return hapticsInfo.get() }
        set { hapticsInfo.set(newValue) }
    }
    private static var hapticsInfo = UserDefaultInfo(key: "haptics", defaultValue: true)

}

private struct UserDefaultInfo<Value> {
    var key: String
    var defaultValue: Value
}

private extension UserDefaultInfo {

    func get() -> Value {
        guard let valueUntyped = UserDefaults.standard.object(forKey: self.key) else {
            return self.defaultValue
        }
        guard let value = valueUntyped as? Value else {
            return self.defaultValue
        }
        return value
    }

    func set(_ value: Value) {
        UserDefaults.standard.set(value, forKey: self.key)
    }
}
