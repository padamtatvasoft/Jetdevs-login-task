//
//  LoginResponse.swift
//  JetDevsHomeWork
//
//  Created by padam on 13/12/22.
//

import Foundation

struct LoginResponse: Codable {
    let resultStatus: Int?
    let errorMessage: String?
    let data: UserDetail?

    enum CodingKeys: String, CodingKey {

        case resultStatus = "result"
        case errorMessage = "error_message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultStatus = try values.decodeIfPresent(Int.self, forKey: .resultStatus)
        errorMessage = try values.decodeIfPresent(String.self, forKey: .errorMessage)
        data = try values.decodeIfPresent(UserDetail.self, forKey: .data)
    }
}
