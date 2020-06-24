//
//  StringExtensions.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/2/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation
import UIKit

extension String {
    mutating func increment() {
        let value = Int(self) ?? 0
        self = "\(value+1)"
    }
    
    mutating func decrement() {
        let value = Int(self) ?? 1
        self = "\(value-1)"
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }
}
