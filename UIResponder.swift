//  UIResponder.swift
//  onTheMap_Fatima
//
//  Created by Fatimah Abdulraheem on 28/01/2019.
//

import Foundation
import UIKit

//this class UIResponder is to handel events such as UIViewController, https://developer.apple.com/documentation/uikit/uiresponder
extension UIResponder {
    private static weak var _CR: UIResponder?
    
    @objc func findFirstResponder(_ sender: Any) {
        UIResponder._CR = self
    }
    
    static var currentFirstResponder: UIResponder? {
        _CR = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _CR
    }
}

