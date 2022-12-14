//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher

class AccountViewController: UIViewController {

	@IBOutlet weak var nonLoginView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var daysLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var headImageView: UIImageView!
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
		nonLoginView.isHidden = false
		loginView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = UserDefaults.user {
            nonLoginView.isHidden = true
            loginView.isHidden = false
            setLoggedInUI(user: user)
        } else {
            nonLoginView.isHidden = false
            loginView.isHidden = true
        }
    }
    // MARK: - Set UI
        private func setLoggedInUI(user: User) {
            nameLabel.text = user.username
            if let imgURL = user.userProfileUrl {
                self.headImageView.setImage(imgURL)
            }
            if let createdDate = user.createdAt?.dateFromString("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
            let components = Set<Calendar.Component>([.day])
            let createdDate = Calendar.current.dateComponents(components, from: createdDate, to: Date())
                daysLabel.text = "Created \(createdDate.day ?? 0) days ago"
            }
        }
    // MARK: - IBAction Methods
	@IBAction func loginButtonTap(_ sender: UIButton) {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true)
    }
}
