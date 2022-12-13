//
//  JetTextfield.swift
//  JetDevsHomeWork
//
//  Created by pcq186 on 09/12/22.
//

import UIKit

protocol JetTextfieldDelegate: AnyObject {
    func textFieldValueChanged(_ textField: UITextField, text: String, isBackSpacePressed: Bool)
}
class JetTextfield: NibView {

    @IBOutlet weak var textFieldTitle: UILabel!
    @IBOutlet weak var txtField: UITextField!
    weak var delegate: JetTextfieldDelegate?
    func setupData(textFieldPlaceHolder: String, title: String, isSecuredTextField: Bool = false) {

        self.textFieldTitle.text = title
        self.txtField.placeholder = textFieldPlaceHolder
        self.txtField.delegate = self
        self.txtField.isSecureTextEntry = isSecuredTextField
        self.txtField.setLeftPaddingPoints(14)
        self.txtField.setRightPaddingPoints(14)
        self.txtField.layer.cornerRadius = 8.0
        self.txtField.layer.borderWidth = 1.0
    }

    var textFieldSecureEntry: Bool {
        get {
            return self.txtField.isSecureTextEntry
        }
        set {
            self.txtField.isSecureTextEntry = newValue
        }
    }
    var text: String? {
        get {
             return self.txtField.text
        }
        set {
            self.txtField.text = newValue
        }
    }
    var placeHolder: String? {
        get {
            return self.txtField.placeholder
        }
        set {
            self.txtField.placeholder = newValue
            self.textFieldTitle.text = newValue
        }
    }
    var borderColor: UIColor? {
        get {
            return self.borderColor
        }
        set {
            self.txtField.layer.borderColor = newValue?.cgColor
        }
    }
    var textFieldTag: Int {
        get {
            return self.txtField.tag
        }
        set {
            self.txtField.tag = newValue
        }
    }
}

extension JetTextfield: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
