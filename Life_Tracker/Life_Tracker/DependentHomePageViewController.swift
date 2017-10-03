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
import CoreMotion
import HealthKit

class DependentHomePageViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var latitude: UILabel!
    
    @IBOutlet weak var longtitude: UILabel!
    
    @IBOutlet weak var speed: UILabel!
    
    @IBOutlet weak var altitude: UILabel!
    
    @IBOutlet weak var steps: UILabel!
    
    @IBOutlet weak var distance:UILabel!
    
    @IBOutlet weak var upstairs: UILabel!
    
    @IBOutlet weak var downstairs: UILabel!
    
    var username:String?
    
    
    @IBAction func askForHelp(_ sender: Any) {
    }
    
    let manager = CLLocationManager()
    let pedometer = CMPedometer()
    
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
        //username = "1234567890"
        
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserTable")
        //username = UserDefaults.standard.object(forKey: "DependentUsername") as? String
        if !((latitude.text?.isEmpty)!||(longtitude.text?.isEmpty)!||(speed.text?.isEmpty)!||(altitude.text?.isEmpty)!){
            table.update(["id": username, "latitude": latitude.text, "steps": steps.text, "distance":distance.text,"upstairs":upstairs.text,"downstairs":downstairs.text,"longtitude":longtitude.text,"speed":speed.text,"altitude":altitude.text ?? "no altitude", "complete": false]) { (result, error) in
                if let err = error {
                    print("ERROR ", err)
                } else  {
                    print("updating the gps and health information")
                }
            }
        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        //begin to update counting steps
        startPedometerUpdates()
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
    
    //begin to retrieve data
    func startPedometerUpdates(){
        //determine the situation of the app
        guard CMPedometer.isStepCountingAvailable() else {
            //self.textView.text = "\n Unavailable!\n"
            return
        }
        //get time
        let cal = Calendar.current
        var comps = cal.dateComponents([.year,.month,.day], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let midnightOfToday = cal.date(from: comps)!
        
        //initialize and retieve real_time data
        self.pedometer.startUpdates (from: midnightOfToday, withHandler: { pedometerData, error in
            //error handle
            guard error == nil else {
                print(error!)
                return
            }
            if let numberOfSteps = pedometerData?.numberOfSteps as? Int {
                self.steps.text = String(numberOfSteps)
            }
            if let distance = pedometerData?.distance as? Double {
                self.distance.text = String(format: "%.2f", distance)
            }
            if let floorsAscended = pedometerData?.floorsAscended as? Int {
                self.upstairs.text = String(floorsAscended)
            }
            if let floorsDescended = pedometerData?.floorsDescended as? Int {
                self.downstairs.text = String(floorsDescended)
            }
            DispatchQueue.main.async {
                //                    self.textView.text = text
            }
            
            
        })
    }
}

