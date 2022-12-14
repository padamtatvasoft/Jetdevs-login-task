//
//  UIImageView+Extensions.swift
//  JetDevsHomeWork
//
//  Created by padam on 14/12/22.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ urlString: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        self.kf.setImage(with: resource, placeholder: UIImage(named: "Avatar"))
    }
}
