//
//  ObjectUserDefaultPropertyWrapper.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation

@propertyWrapper
public struct ObjectUserDefaultPropertyWrapper<T: Codable> {
    public var key: String
    public var defaultValue: T?
    
    public init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T? {
        get {
            guard let data = UserDefaults.standard.value(forKey: key) as? Data else {
                return defaultValue
            }
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                return object
            } catch {
                print(error)
            }
            return nil
        }
        set {
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: key)
                return
            }
            do {
                let encode = JSONEncoder()
                let data = try encode.encode(value)
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print(error)
            }
        }
    }
}
