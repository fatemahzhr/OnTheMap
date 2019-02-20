//  ContainerViewController.swift
//  onTheMap_Fatima
//
//  Created by Fatimah Abdulraheem on 28/01/2019.
//

//The purpose of this class is to delete repeated codes
import UIKit

class UsedButtonsVC: UIViewController {
    var LD: LData?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareButtns()
        UpdateUdacityUsersLocation()
    }
    
    func prepareButtns() {
        //create the buttons that will be repeated on two UIViews:
        //Refresh button:
        let btnRef = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshLocationsTapped(_:)))
        //Add new location button:
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocationTapped(_:)))
        //Logout button:
        let btnLogout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutTapped(_:)))

        //set the locations of the buttons to be in the right or on the left:
        navigationItem.rightBarButtonItems = [btnAdd, btnRef]
        navigationItem.leftBarButtonItem = btnLogout
    }
    
    @objc private func addLocationTapped(_ sender: Any) {
        let nv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostLocationViewController") as! UINavigationController
        present(nv, animated: true, completion: nil)
    }
    
    @objc private func refreshLocationsTapped(_ sender: Any) {
        //refresh button will upload the locations again the see the new added locations:
        UpdateUdacityUsersLocation()
    }
    
    @objc private func logoutTapped(_ sender: Any) {
        //call delete session API for deletion:
        APIMethods.deletSession(completion: {_ in ("error")})
        self.dismiss(animated: true, completion: nil)
    }//end of Logout
    
    //Update Udacity Users Location on the Map:
    private func UpdateUdacityUsersLocation() {
        APIMethods.Parser.getStudentLocations { (data) in
            //if errors then show error messges using WarningMsg function, then stop the method to be performed
            //check Internet Connection:
            guard let data = data else {
                self.WarningMsg(title: "Error", message: "Error Found: There is no Interent connection!")
                return
            }
            //if no pins on the map!
            guard data.UdacityUsersL.count > 0 else {
                self.WarningMsg(title: "Error", message: "Error Found: there is no pins on the map found!")
                return
            }
            self.LD = data //update Locations Data
        }
    }
}//end of UsedButtonsVC class
