//  CheckPostedLocation.swift
//  OnTheMap Project
//
//  Created by Fatimah Abdulraheem on 28/01/2019.
//

import UIKit
import MapKit

class CheckPostedLocation: UIViewController {
    //set the outlets:
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnFinish: UIButton!
    //give intital values to the variables:
    var location: SLocation?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var r: String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //call a function to show the map when the view will be loaded at the first time
        mapPrepare()
    }
    @IBAction func finishTapped(_ sender: UIButton) {
        //called postStudentLocation function to add the new location:
        APIMethods.Parser.postStudentLocation(self.location!, url: r, latitude: latitude, longitude: longitude, completion: { (result, error) in
            guard error == nil else {
                self.WarningMsg(title: "Error", message: "Error Found: Please post the correct coordinates!")
                return
            }
        })
        self.dismiss(animated: true, completion: nil)
    }//end of finishTapped

    //Note: This code is from: https://classroom.udacity.com/nanodegrees/nd003-connect/parts/0a0bbced-e315-4a81-8290-33bc6c8e00a8/modules/b1fe8402-60cc-48f7-9a27-fff48b8d3ff8/lessons/4cc266a1-f255-40b3-90fe-74cd032f7e9e/concepts/0697a3db-4135-433f-ad12-112c44d16513
    private func mapPrepare() {
        guard let location = location else { return }
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        let c = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let n = MKPointAnnotation()
        n.coordinate = c
        n.title = location.mapString
        mapView.addAnnotation(n)
        let are_a = MKCoordinateRegion(center: c, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(are_a, animated: true)
    }
}

extension CheckPostedLocation: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var v = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if v == nil {
            v = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            v!.canShowCallout = true
            v!.pinTintColor = .red
            v!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            v!.annotation = annotation
        }
        return v
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let a = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let r = URL(string: toOpen), a.canOpenURL(r) {
                a.open(r, options: [:], completionHandler: nil)
            }
        }
    }//end of mapView function
}//end of CheckPostedLocation class
