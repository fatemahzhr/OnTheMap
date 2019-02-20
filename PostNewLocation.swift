//  PostNewLocation.swift
//  OnTheMap Project
//
//  Created by Fatimah Abdulraheem on  28/01/2019.
//

import UIKit
import CoreLocation

class PostNewLocation: UIViewController {
    //set the outlet:
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaLinkTextField: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        //Add "Cancel" button to the UIView
        UserInterfacePrepare()
    }
    
    @IBAction func findLocationBtn(_ sender: Any) {
        guard let addr = locationTextField.text,
            let websit = mediaLinkTextField.text,
            //check that user had added two values successfully
            addr != "", websit != "" else {
                self.WarningMsg(title: "Incomplete!", message: "The two fields are required, please fill them then try again")
                return
        }
        let studentLocation = SLocation(mapString: addr, mediaURL: websit)
        //call placeCordinatesOnMap function to save the data from the map to be used later
        placeCordinatesOnMap(studentLocation)
    }
    
    private func placeCordinatesOnMap(_ studentLocation: SLocation) {
        let x = self.ActivityCircle()
        //call CLGeocoder function to convert between cordinates
        //https://developer.apple.com/documentation/corelocation/clgeocoder
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, err) in
            x.stopAnimating()
            guard let loc = placeMarks?.first?.location else {
                self.WarningMsg(title: "Error", message: "Error Found: Please post the correct coordinates!")
                return }
            //save the location to be sending in the Segue to the next mapview
            var addr = studentLocation
            addr.latitude = loc.coordinate.latitude
            addr.longitude = loc.coordinate.longitude
            self.performSegue(withIdentifier: "mapSegue", sender: addr)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue", let viewContr = segue.destination as? CheckPostedLocation {
            viewContr.location = (sender as! SLocation)
        }
    }
    
    private func UserInterfacePrepare() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.dismissFun(_:)))
        setupX()
    }
    
    func setupX(){
        mediaLinkTextField.delegate = self
        locationTextField.delegate = self
    }//end of setupX
    
    //Cancel button job:
    @objc private func dismissFun(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}//end of PostNewLocation class
