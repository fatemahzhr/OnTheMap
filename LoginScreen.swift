//  LoginScreen.swift
//  OnTheMap Project
//
//  Created by Fatimah Abdulraheem on  28/01/2019.
//

import UIKit

class LoginScreen: UIViewController{

//Define the outlets:
    @IBOutlet weak var userNameTextBox: UITextField!
    @IBOutlet weak var passTextBox: UITextField!
    @IBOutlet weak var lognBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //set the textboxes delegate:
        userNameTextBox.delegate = self
        passTextBox.delegate = self
    }

    
//LoginBtnFun Function:
    @IBAction func loginBtn(_ sender: Any) {
        passTextBox.resignFirstResponder()
        
        guard let username = userNameTextBox.text else {return}
        guard let password = passTextBox.text else {return}
        
        let x = self.ActivityCircle() //start the indecator for the user when the login button when it will be prssed
        
        if username.isEmpty || password.isEmpty {
            let message = "Please fill both the email and password"
            x.stopAnimating()
            self.WarningMsg(title: "Error", message: message)
            return
        } else {
            //call the postSession to perform the required API method:
            APIMethods.postSession(username: userNameTextBox.text!, password: passTextBox.text!) { (errString) in
                guard errString == nil else {
                    self.WarningMsg(title: "Error", message: errString!)
                    x.stopAnimating()
                    return
                }
                DispatchQueue.main.async {
                    //when login is correct then move to the next view:
                    x.stopAnimating()
                    self.performSegue(withIdentifier: "Login", sender: nil)
                }
            }            
        }//end of else
    }
    
//SignUp:
    @IBAction func signUpBtn(_ sender: Any) {
        //Open Udacity's SignUp page:
        if let r = URL(string: "https://www.udacity.com/account/auth#!/signup"),
            UIApplication.shared.canOpenURL(r) {
            UIApplication.shared.open(r, options: [:], completionHandler: nil)
        }
    }
}//end of class
