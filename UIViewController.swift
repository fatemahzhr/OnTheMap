//  UIViewController+UIResponder.swift
//  onTheMap_Fatima
//
//  Created by Fatimah Abdulraheem on 27/01/2019.
//

//Reference:
//the source code of some of the code in this project was used from this link: https://github.com/ATahhan/Example12/tree/TODO

import Foundation
import UIKit

//create the indicator circle when the user will be waiting
extension UIViewController {
    func ActivityCircle() -> UIActivityIndicatorView {
        let acti = UIActivityIndicatorView(style: .gray)
        //add a subview to show the indicator at the biginning:
        self.view.addSubview(acti)
        self.view.bringSubviewToFront(acti)
        acti.center = self.view.center //the place of the indicator will be in the middle of the view
        acti.hidesWhenStopped = true
        acti.startAnimating()
        return acti
    }
    //show the warning messages using this function
    func WarningMsg(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil) //show the allert msg to the user
    }
}

//when the user will stop writing in the textfield:
extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

