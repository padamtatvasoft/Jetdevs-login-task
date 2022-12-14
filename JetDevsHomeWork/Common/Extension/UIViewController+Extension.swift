//
//  UIViewController+Extension.swift
//  JetDevsHomeWork
//
//  Created by padam on 13/12/22.
//

import Foundation
import UIKit
import SVProgressHUD
import Toast_Swift
extension UIViewController {
    func showAlert(withMessage message: String?, title: String = appName,
                   preferredStyle: UIAlertController.Style = .alert,
                   withActions actions: UIAlertAction...) {
        if let message = message {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            if actions.count == 0 {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            } else {
                for action in actions {
                    alert.addAction(action)
                }
            }
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func showProgressActivity() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show(withStatus: "Logging in...")
        }
    }
    func hideProgressActivity() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    func alertToast(_ message: String) {
        DispatchQueue.main.async {
            self.view.hideAllToasts()
            self.view.makeToast(message)
        }
    }
}
