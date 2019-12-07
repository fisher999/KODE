//
//  UIViewController+Alert.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

extension UIViewController {
    func showDefaultAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        self.present(alertController,
                     animated: true,
                     completion: nil)        
    }
    
    func showAlertWithActions(title: String?,
                              message: String?,
                              actionTitles: [String],
                              selectedAction: ((_ index: Int) -> ())?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            alertController.addAction(UIAlertAction(title: title, style: .default, handler: { alert in
                if let block = selectedAction {
                    block(index)
                }
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
