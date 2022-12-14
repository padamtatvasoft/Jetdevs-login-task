//
//  APIError.swift
//  JetDevsHomeWork
//
//  Created by padam on 13/12/22.
//

import Foundation
import UIKit

enum APIError: Error {
    case connectionError(code: Int) // Error comes from Alamofire
    case middlewareError(code: Int, message: String) // Error comes from middleware
    case invalidJSONFormat
    case offline
    case success
    case tokenExpired(code: Int, message: String)
}

enum ErrorCodeType: Int {
    case offline = 10101
    case tokenExpire = 401
}

extension APIError {
    var errorCodeType: ErrorCodeType? {
        switch self {
        case .middlewareError(let code, _):
            let errorCodeType = ErrorCodeType(rawValue: code)
            return errorCodeType
        case .tokenExpired(let code, _):
            let errorCodeType = ErrorCodeType(rawValue: code)
            return errorCodeType
        case .connectionError(let code):
            let isInsecureErrorCode = NetworkConstants.insecureConnectionErrorCodes.contains(code)
            var errorCodeType: ErrorCodeType?
            errorCodeType = isInsecureErrorCode ? ErrorCodeType(rawValue: 998) : ErrorCodeType(rawValue: code)
            return errorCodeType
        default:
            return nil
        }
    }
}

struct NetworkConstants {
    static let insecureConnectionErrorCodes = [
        Int(CFNetworkErrors.cfurlErrorServerCertificateNotYetValid.rawValue),
        Int(CFNetworkErrors.cfurlErrorServerCertificateUntrusted.rawValue),
        Int(CFNetworkErrors.cfurlErrorServerCertificateHasBadDate.rawValue),
        Int(CFNetworkErrors.cfurlErrorServerCertificateHasUnknownRoot.rawValue),
        Int(CFNetworkErrors.cfurlErrorClientCertificateRejected.rawValue),
        Int(CFNetworkErrors.cfurlErrorClientCertificateRequired.rawValue),
        Int(CFNetworkErrors.cfErrorHTTPSProxyConnectionFailure.rawValue),
        Int(CFNetworkErrors.cfurlErrorSecureConnectionFailed.rawValue),
        Int(CFNetworkErrors.cfurlErrorCannotLoadFromNetwork.rawValue),
        Int(CFNetworkErrors.cfurlErrorCancelled.rawValue)
    ]
}
