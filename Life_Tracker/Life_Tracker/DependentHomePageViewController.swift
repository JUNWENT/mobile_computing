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
    
    @IBOutlet weak var showingPerson: UILabel!
    var username:String?
    var showing = UserDefaults.standard.object(forKey: "GuardianDependent") as? String
    
    var selfLatitude:String?
    var selfLongtitude:String?
    var selfSpeed:String?
    var selfAltitude:String?
    var selfsteps:String?
    var selfDistance:String?
    var selfUpstairs:String?
    var selfDownstairs:String?
    
    
    @IBAction func askForHelp(_ sender: Any) {
    }
    
    let manager = CLLocationManager()
    let pedometer = CMPedometer()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(showing ?? "no one to show")
        print("show")
        username = UserDefaults.standard.object(forKey: "Username") as? String
        // get local gps data
        let selflocation = locations[0]
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation = CLLocationCoordinate2DMake(selflocation.coordinate.latitude, selflocation.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        //map.setRegion(region, animated: true)
        //self.map.showsUserLocation = true
        // store local data
        selfLatitude = String(selflocation.coordinate.latitude)
        selfLongtitude = String(selflocation.coordinate.longitude)
        selfSpeed = String(selflocation.speed)
        selfAltitude = String(selflocation.altitude)
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserTable")
        if(username != nil){
            if !((latitude.text?.isEmpty)!||(longtitude.text?.isEmpty)!||(speed.text?.isEmpty)!||(altitude.text?.isEmpty)!){
                table.update(["id": username!, "latitude": selfLatitude ?? "0", "steps": selfsteps ?? "0", "distance":selfDistance ?? "0","upstairs":selfUpstairs ?? "0","downstairs":selfDownstairs ?? "0","longtitude":selfLongtitude ?? "0","speed":selfSpeed ?? "0","altitude":selfAltitude ?? "0", "complete": false]) { (result, error) in
                    if let err = error {
                        print("ERROR ", err)
                    } else  {
                        print("updating the gps and health information")
                    }
                }
            }
        }
        
        if showing == username {
            showingPerson.text = "Yourself"
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
        } else if (showing != username){
            showingPerson.text = showing
            table.read { (result, error) in
                if let err = error {
                    self.displayAlertMessage(useMessage: "Please check you network and try again.")
                    return
                        print("ERROR ", err)
                } else if let items = result?.items {
                    for item in items {
                        if item["id"] as? String == self.showing {
                            self.latitude.text = item["latitude"] as? String
                            self.longtitude.text = item["longtitude"] as? String
                            self.speed.text = item["speed"] as? String
                            self.altitude.text = item["altitude"] as? String
                            self.steps.text = item["steps"] as? String
                            self.distance.text = item["distance"] as? String
                            self.upstairs.text = item["upstairs"] as? String
                            self.downstairs.text = item["downstairs"] as? String
                        }
                    }
                    let lat = Double(self.latitude.text!)
                    let long = Double(self.longtitude.text!)
                    print (lat!)
                    print (long!)
                    let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, long!)
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    self.map.setRegion(region, animated: true)
                    self.map.isZoomEnabled = true
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = "xxx is here"
                    self.map.addAnnotation(annotation)
                }
            }

        }
 
    }
    
    
    @IBAction func backToUser(_ sender: UIButton) {
        showing = username
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
        let show = UserDefaults.standard.object(forKey: "GuardianDependent") as? String
        username = UserDefaults.standard.object(forKey: "Username") as? String
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
                self.selfsteps = String(numberOfSteps)
                
            }
            if let distance = pedometerData?.distance as? Double {
                self.selfDistance = String(format: "%.2f", distance)
                
            }
            if let floorsAscended = pedometerData?.floorsAscended as? Int {
                self.selfUpstairs = String(floorsAscended)
                
            }
            if let floorsDescended = pedometerData?.floorsDescended as? Int {
                self.selfDownstairs = String(floorsDescended)
                
            }
            if(show == self.username){
                self.steps.text = self.selfsteps
                self.distance.text = self.selfDistance
                self.upstairs.text = self.selfUpstairs
                self.downstairs.text = self.selfDownstairs
            }
            DispatchQueue.main.async {
                //                    self.textView.text = text
            }
        })
        
       
        
    }
    
    func displayAlertMessage(useMessage:String){
        let alert = UIAlertController(title:"ALERT",message:useMessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}

