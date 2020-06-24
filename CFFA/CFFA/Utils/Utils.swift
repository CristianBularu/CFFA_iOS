//
//  Utils.swift
//  CFFA
//
//  Created by Cristian Bularu on 2/19/20.
//  Copyright © 2020 Cristian Bularu. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInstantiable: class {
    
    static var storyboardName: String { get }
    static var identifier: String { get }
    static func instantiate() -> Self
}

extension StoryboardInstantiable {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: Self.storyboardName, bundle: nil)
    }
    
    static func instantiate() -> Self {
        return storyboard.instantiateViewController(withIdentifier: identifier) !! "Could not instantiate \(Self.self) from storyboard file."
    }
}


infix operator !!

func !!<T>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    if let x = wrapped { return x }
    fatalError("(failureText()), Function: (#function), Line: (#line), Column: (#column)")
}

func !!<T>(wrapped: Any?, failureText: @autoclosure () -> String) -> T {
    if let x = wrapped as? T { return x }
    fatalError("(failureText()), Function: (#function), Line: (#line), Column: (#column)")
}
