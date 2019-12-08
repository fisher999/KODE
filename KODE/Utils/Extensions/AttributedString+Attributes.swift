//
//  AttributedString+Attributes.swift
//  KODE
//
//  Created by Victor on 08.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    func withFont(_ font: UIFont) -> NSAttributedString {
        let newString = NSMutableAttributedString(attributedString: self)
        newString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: newString.length - 1))
        return newString
    }
}
