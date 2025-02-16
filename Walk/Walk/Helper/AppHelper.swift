//
//  AppHelper.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/16/25.
//

import Foundation
import UIKit

struct AppHelper {
    static func showAlert(title: String, message: String, okTitle: String = "확인", cancelTitle: String? = nil, okAction: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            okAction?()
        }
        alert.addAction(okAction)
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            alert.addAction(cancelAction)
        }
    }
}
