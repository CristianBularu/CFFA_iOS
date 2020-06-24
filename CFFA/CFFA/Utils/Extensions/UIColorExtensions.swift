//
//  UIColorExtensions.swift
//  CFFA
//
//  Created by Cristian Bularu on 3/6/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
    
    struct Tint {
      static var c0: UIColor  { return UIColor.init(rgb: 0x522CB5) }
      static var c1: UIColor  { return UIColor.init(rgb: 0x20AFFC) }
      static var c2: UIColor  { return UIColor.init(rgb: 0xFC7E52) }
      static var c3: UIColor  { return UIColor.init(rgb: 0xED63D2) }
      static var c4: UIColor  { return UIColor.init(rgb: 0x31CA74) }
      static var c5: UIColor  { return UIColor.init(rgb: 0xFEC12D) }
      static var c6: UIColor  { return UIColor.init(rgb: 0x28BCD6) }
      static var c7: UIColor  { return UIColor.init(rgb: 0x3C4959) }
      static var c8: UIColor  { return UIColor.init(rgb: 0xD64D4D) }
      static var c9: UIColor  { return UIColor.init(rgb: 0x1B2D41) }
    }
}
