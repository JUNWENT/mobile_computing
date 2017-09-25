//
//  DependentViewController.swift
//  Life_Tracker
//
//  Created by Mingyan Wei on 21/9/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DependentHomePageViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var latitude: UILabel!
    
    @IBOutlet weak var longtitude: UILabel!
    
    @IBOutlet weak var speed: UILabel!
    
    @IBOutlet weak var altitude: UILabel!
    
    @IBAction func askForHelp(_ sender: Any) {
    }
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        
        latitude.text = String(location.coordinate.latitude)
        longtitude.text = String(location.coordinate.longitude)
        speed.text = String(location.speed)
        altitude.text = String(location.altitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
