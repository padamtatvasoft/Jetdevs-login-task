//
//  KeyChain.swift
//  JetDevsHomeWork
//
//  Created by padam on 14/12/22.
//

import Foundation
import Security
import UIKit

class KeyChain {
    class func saveXAccToken(key: NSString = "X-Acc", data: String) {
        let userAccount                   = "X-AccToken"
        let kSecClassValue                = NSString(format: kSecClass)
        let kSecAttrAccountValue          = NSString(format: kSecAttrAccount)
        let kSecValueDataValue            = NSString(format: kSecValueData)
        let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
        let kSecAttrServiceValue          = NSString(format: kSecAttrService)
        let dataFromString: NSData = data.data(using: .utf8,
                                               allowLossyConversion: false) as? NSData ?? NSData()
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [
            kSecClassGenericPasswordValue,
            key,
            userAccount,
            dataFromString],
            forKeys: [
                kSecClassValue,
                kSecAttrServiceValue,
                kSecAttrAccountValue,
                kSecValueDataValue])
        SecItemDelete(keychainQuery as CFDictionary)
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
}
