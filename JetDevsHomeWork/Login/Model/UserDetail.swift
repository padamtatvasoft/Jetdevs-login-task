//
//  UserDetail.swift
//  JetDevsHomeWork
//
//  Created by padam on 13/12/22.
//

import Foundation

struct UserDetail: Codable {
    let userObj: User?

    enum CodingKeys: String, CodingKey {
        case userObj = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userObj = try values.decodeIfPresent(User.self, forKey: .userObj)
    }

}
