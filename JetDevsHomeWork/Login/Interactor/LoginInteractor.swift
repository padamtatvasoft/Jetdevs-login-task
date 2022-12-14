import Foundation
import RxSwift

struct LoginInteractor {
    static func loginAPICall(username: String, password: String) -> Observable<APIResult<LoginResponse>> {
        return APIClient.shared.login(username: username, password: password)
    }
}
