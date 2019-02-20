//  Note: This code is obtained from: PinSample on Udacity
//
//  Created by Jason on 3/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

//Note: This code is from: https://classroom.udacity.com/nanodegrees/nd003-connect/parts/0a0bbced-e315-4a81-8290-33bc6c8e00a8/modules/b1fe8402-60cc-48f7-9a27-fff48b8d3ff8/lessons/4cc266a1-f255-40b3-90fe-74cd032f7e9e/concepts/0697a3db-4135-433f-ad12-112c44d16513
import UIKit
import MapKit

//This class "Mapp" will inhreat from UsedButtonsVC to create the required (Logout, Add, and Refresh) buttons.
class Mapp: UsedButtonsVC, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    override var LD: LData? {
        didSet {
            updatePins()//update the pins on the map
        }
    }
    
    //update the pins on the map:
    func updatePins() {
        guard let locations = LD?.UdacityUsersL else { return }
        var annotations = [MKPointAnnotation]()
        for location in locations {
            guard let latitude = location.latitude, let longitude = location.longitude else { continue }
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let f = location.firstName
            let l = location.lastName
            let mediaURL = location.mediaURL
            let n = MKPointAnnotation()
            n.coordinate = coordinate
            //show data: 
            n.title = "\(f ?? "") \(l ?? "")"
            n.subtitle = mediaURL
            annotations.append(n)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    //create the pin on the map:
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var p = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if p == nil {
            p = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            p!.canShowCallout = true
            p!.pinTintColor = .red
            p!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            p!.annotation = annotation
        }
        return p
    }
    
    //open the URL when the pin will be clicked:
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let sta = view.annotation?.subtitle!,
                let url = URL(string: sta), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
