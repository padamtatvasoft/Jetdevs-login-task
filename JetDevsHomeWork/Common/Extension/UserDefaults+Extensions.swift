//
//  UserDefaults+Extensions.swift
//  JetDevsHomeWork
//
//  Created by padam on 14/12/22.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let user = "user"
    }
    class var user: User? {
        get {
            if let user = UserDefaults.standard.object(forKey: Keys.user) as? Data {
                let decoder = JSONDecoder()
                if let storedUser = try? decoder.decode(User.self, from: user) {
                    return storedUser
                }
            }
            return nil
        }
        set {
            if let user = newValue {
                if let encodedData = try? JSONEncoder().encode(user) {
                    UserDefaults.standard.set(encodedData, forKey: Keys.user)
                }
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.user)
            }
            UserDefaults.standard.synchronize()
        }
    }
}
