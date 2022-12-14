//
//  APIManager.swift
//  JetDevsHomeWork
//
//  Created by padam on 13/12/22.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class APIManager {
    static let shared: APIManager = {
        let instance = APIManager()
        return instance
    }()
    let sessionManager: SessionManager
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 240
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    func requestObservable(api: APIRouter) -> Observable<DataRequest> {
        return sessionManager.rx.request(urlRequest: api)
    }
}
