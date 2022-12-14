//
//  APIClient.swift
//  JetDevsHomeWork
//
//  Created by padam on 13/12/22.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import CoreServices

let noInternetConnection = "noInternetConnection"

class APIClient {
    static let shared: APIClient = {
        let instance = APIClient()
        return instance
    }()
    init() {
    }
    func login(username: String, password: String) -> Observable<APIResult<LoginResponse>> {
        return APIClient.handleDataRequest(
            dataRequest: APIManager.shared.requestObservable(
                api: APIRouter.login(email: username, password: password)))
                .map { (response) -> APIResult<LoginResponse> in
                if let loginResponse = response {
                    if loginResponse.resultStatus == 0 {
                        return APIResult.failure(
                            error: APIError.middlewareError(code: 101,
                                                            message: loginResponse.errorMessage
                                                            ?? "Something went wrong later.")
                        )
                    } else {
                        return APIResult.success(value: loginResponse)
                    }
                } else {
                    return APIResult.failure(
                        error: APIError.middlewareError(code: 101,
                                                        message: "Something went wrong later."))
                }
            }
        }
}

extension APIClient {
    @discardableResult
    private static func handleDataRequest(dataRequest: Observable<DataRequest>) -> Observable<LoginResponse?> {
        if NetworkReachabilityManager()?.isReachable == false {
            return Observable<LoginResponse?>.create({ (observer) -> Disposable in
               // observer.on(.next([noInternetConnection: true]))
                observer.on(.completed)
                return Disposables.create()
            })
        }
        return Observable<LoginResponse?>.create({ (observer) -> Disposable in
            dataRequest.observeOn(MainScheduler.instance).subscribe({ (event) in

                switch event {
                case .next(let eventResponse):
                    print(eventResponse.debugDescription)
                    eventResponse.responseData(completionHandler: { (dataResponse) in
                        if dataResponse.response?.statusCode == 401 {
                            // Check Access Token expire
                            var dictError: [String: Any] = [:]
                            dictError["status"] = dataResponse.response?.statusCode
                            dictError["success"] = false
                            dictError["message"] = "Authorization has been denied for this request."
                            observer.on(.completed)
                            return
                        }
                        switch dataResponse.result {
                        case .success(let data):
                            let jsonDecoder = JSONDecoder()
                            do {
                                if let responseHeader = eventResponse.response?.allHeaderFields,
                                    let strxAcc = responseHeader["X-Acc"] as? String {
                                    KeyChain.saveXAccToken(data: strxAcc)
                                }
                                let json = try jsonDecoder.decode(LoginResponse.self, from: data)
                                let resultData = json
                                observer.onNext(resultData)
                            } catch let error {
                                print(error.localizedDescription)
                                observer.onNext(nil)
                            }
                        case .failure(let error):
                            let errorCode = (error as NSError).code
                            var dictError: [String: Any] = [:]
                            dictError["status"] = errorCode
                            dictError["message"] = error.localizedDescription
                            if errorCode == -1005 || errorCode == -1009 {
                                dictError[noInternetConnection] = true
                            }
                           // observer.on(.next(dictError))
                            observer.on(.completed)
                        }
                    })
                case .error(let error):
                    print(error)
                    observer.onNext(nil)
                case .completed:
                    observer.onCompleted()
                }
            })
        })
    }
}
