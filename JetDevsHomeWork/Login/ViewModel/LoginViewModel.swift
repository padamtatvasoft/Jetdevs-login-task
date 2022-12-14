import Foundation
import RxSwift
import RxRelay
import RxCocoa

class LoginViewModel: BaseViewModel {
    var state = PublishSubject<ViewModelState<LoginViewModel>>()
    var email: BehaviorRelay<String> = BehaviorRelay(value: "")
    var password: BehaviorRelay<String> = BehaviorRelay(value: "")
    var isValidEmailAddress: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var isValidPassword: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    override init() {
        super.init()
    }
    func validateEmailField() {
        if email.value.isValidEmail() == false {
            self.isValidEmailAddress.accept(false)
        } else {
            self.isValidEmailAddress.accept(true)
        }
    }
    func validatePasswordField() {
         if password.value.isValidPassword() == false {
            self.isValidPassword.accept(false)
            self.toastMessage.onNext("Please enter a password.")
         } else {
            self.isValidPassword.accept(true)
        }
    }
    func callLoginAPI() {
        if self.isValidEmailAddress.value && self.isValidPassword.value {
           self.state.onNext(.loading)
            LoginInteractor.loginAPICall(username: email.value, password: password.value)
                .observeOn(SerialDispatchQueueScheduler(qos: .default))
                .subscribe(onNext: { [weak self] (result) in
                    guard let `self` = self else {
                        return
                    }
                    switch result {
                    case .success(let response):
                        if let userObj = response.data?.userObj {
                            UserDefaults.user = userObj
                        }
                        self.state.onNext(.success(self))
                    case .failure(let error):
                         self.errorInApi(error)
                        self.state.onNext(.failure)
                    }
                }).disposed(by: disposeBag)
        }
    }
}
