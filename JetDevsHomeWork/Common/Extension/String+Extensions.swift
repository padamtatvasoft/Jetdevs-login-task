//
//  String+Extensions.swift
//  JetDevsHomeWork
//
//  Created by padam on 13/12/22.
//

import Foundation
extension String {
    func isValidEmail() -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: self)
    }
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{3,17}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    func dateFromString(_ format: String) -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = TimeZone.current
            return formatter.date(from: self)
    }
}
