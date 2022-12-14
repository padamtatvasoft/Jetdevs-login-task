//
//  APIResult.swift
//  JetDevsHomeWork
//
//  Created by padam on 13/12/22.
//

import Foundation
enum APIResult <Value> {
    case success(value: Value)
    case failure(error: APIError)
    // Remove it if not needed.
    init(_ result: () throws -> Value) {
        do {
            let value = try result()
            self = .success(value: value)
        } catch let error as APIError {
            self = .failure(error: error)
        } catch let error {
            print(error)
            self = .failure(error: APIError.invalidJSONFormat)
        }
    }
}
