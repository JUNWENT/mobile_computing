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
    
    @IBOutlet weak var textView: UITextView!
    
    var username:String?
    
    var table : MSSyncTable?
    var store : MSCoreDataStore?
    
    
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
        
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
        self.store = MSCoreDataStore(managedObjectContext: managedObjectContext)
        client.syncContext = MSSyncContext(delegate: nil, dataSource: self.store, callback: nil)
        self.table = client.syncTable(withName: "TodoItem")
        
        let itemToInsert = ["latitude": latitude.text!, "phoneNumber": username!, "longtitude":longtitude.text!,"speed":speed.text!,"altitude":altitude.text!, "complete": false, "__createdAt": Date()] as [String : Any]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.table!.insert(itemToInsert) {
            (item, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error != nil {
                print("Error: " + (error! as NSError).description)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        
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
            self.textView.text = "\n Unavailable!\n"
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
                var text = "---Workout---\n"
                if let numberOfSteps = pedometerData?.numberOfSteps {
                    text += "steps: \(numberOfSteps)\n"
                }
                if let distance = pedometerData?.distance {
                    text += "distance: \(distance)\n"
                }
                if let floorsAscended = pedometerData?.floorsAscended {
                    text += "upstairs: \(floorsAscended)\n"
                }
                if let floorsDescended = pedometerData?.floorsDescended {
                    text += "downstairs: \(floorsDescended)\n"
                }
                if #available(iOS 9.0, *) {
                    if let currentPace = pedometerData?.currentPace {
                        text += "speed: \(currentPace)m/s\n"
                    }
                } else {
                    // Fallback on earlier versions
                }
                if #available(iOS 9.0, *) {
                    if let currentCadence = pedometerData?.currentCadence {
                        text += "speed: \(currentCadence)steps/s\n"
                    }
                } else {
                    // Fallback on earlier versions
                }
                DispatchQueue.main.async {
                    
                    self.textView.text = text
                }
                
            })
    }
    }

