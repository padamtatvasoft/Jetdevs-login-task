//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by padam on 12/12/22.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: JetTextfield!
    @IBOutlet weak var passwordTextField: JetTextfield!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    // MARK: - Variables
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    // MARK: - Setup
    private func setup() {
        setupUI()
        setupBindings()
    }
    private func setupUI() {
        self.emailTextField.setupData(textFieldPlaceHolder: "Email",
                                      title: "Email",
                                      isSecuredTextField: false,
                                      errorMessage: "Invalid email address")
        self.passwordTextField.setupData(textFieldPlaceHolder: "Password",
                                         title: "Password",
                                         isSecuredTextField: true,
                                         errorMessage:
                                            "Password must contains one uppercase, one lowercase and one digit.")
        self.viewModel.alertDialog.subscribe(onNext: { [weak self] alertMessage in
            guard let `self` = self else {
                return
            }
            self.showAlert(withMessage: alertMessage)
        }).disposed(by: disposeBag)
        viewModel.state.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] state in
            guard let `self` = self else {
                return
            }
            switch state {
            case .loading:
                self.showProgressActivity()
            case .failure:
                self.hideProgressActivity()
            case .success:
                self.dismiss(animated: true)
                self.hideProgressActivity()
            }
        }).disposed(by: disposeBag)
    }
    private func setupBindings() {
        self.emailTextField.txtField.rx.text.orEmpty.bind(to: self.viewModel.email).disposed(by: disposeBag)
        self.passwordTextField.txtField.rx.text.orEmpty.bind(to: self.viewModel.password).disposed(by: disposeBag)
        self.emailTextField.txtField.delegate = self
        self.passwordTextField.txtField.delegate = self
        self.btnLogin.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            guard let `self` = self else {
                return
            }
            self.viewModel.validateEmailField()
            self.viewModel.validatePasswordField()
            self.viewModel.callLoginAPI()
        }).disposed(by: disposeBag)
        self.btnClose.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            guard let `self` = self else {
                return
            }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        self.viewModel.isValidEmailAddress.subscribe(onNext: { isValid in
            self.updateLoginButton()
            self.emailTextField.lblError.isHidden = isValid
            self.emailTextField.borderColor = isValid ? UIColor(named: "buttonDisabled") : UIColor.red
        }).disposed(by: disposeBag)
        self.viewModel.isValidPassword.subscribe(onNext: { isValid in
            self.updateLoginButton()
            self.passwordTextField.borderColor = isValid ? UIColor(named: "buttonDisabled") : UIColor.red
            self.passwordTextField.lblError.isHidden = isValid
        }).disposed(by: disposeBag)
    }
    func updateLoginButton() {
        if self.viewModel.email.value ==  "" || self.viewModel.password.value ==  "" {
            self.btnLogin.isEnabled = false
            self.btnLogin.backgroundColor = UIColor(named: "buttonDisabled")
        } else if self.viewModel.isValidEmailAddress.value == false || self.viewModel.isValidPassword.value == false {
            self.btnLogin.isEnabled = false
            self.btnLogin.backgroundColor = UIColor(named: "buttonDisabled")
        } else {
            self.btnLogin.isEnabled = true
            self.btnLogin.backgroundColor = UIColor(named: "buttonEnabled")
        }
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.text?.count == 0 {
            if string == " " {
                return false
            }
        }
        if textField == self.emailTextField.txtField {
            self.viewModel.validateEmailField()
        } else {
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            self.viewModel.validatePasswordField()
            return newString.count <= 14
        }
        return true
    }
}
