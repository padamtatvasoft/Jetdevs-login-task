//
//  BaseViewModel.swift
//  JetDevsHomeWork
//
//  Created by padam on 13/12/22.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

enum ViewModelState<T> {
    case loading
    case failure
    case success(T)
}

enum CoordinatorError {
    case noInternetConnection
    case tokenExpired
}

typealias CoordinationTask = (() -> Void)?

class BaseViewModel {
    // Dispose Bag
    let disposeBag = DisposeBag()
    let alertDialog = PublishSubject<(String)>()
    let toastMessage = PublishSubject<(String)>()
    static let coordinatorError = PublishSubject<(CoordinationTask, CoordinatorError)>()
    static let reloadDashboard = PublishSubject<(Bool)>()
    static let backFromSendMail = PublishSubject<([URL])>()
    func errorInApi(_ error: APIError) {
        switch error {
        case .offline:
            self.alertDialog.onNext(
                ("Internet connection appears to be offline. Kindly check your internet connection.")
            )
        case .connectionError:
            self.alertDialog.onNext(("Connection Error"))
        case .middlewareError(let code, let message):
            print(code)
            self.alertDialog.onNext((message))
        case .invalidJSONFormat:
            print("invalidJSONFormat")
        case .success:
            print("success")
        case .tokenExpired:
            print("tokenExpired")
        }
    }
}
