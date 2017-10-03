//
//  GuardianHomePageViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/24.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit
import MapKit

class GuardianHomePageViewController: UIViewController {
    
    var username:String?
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var latitude: UILabel!
    
    @IBOutlet weak var longtitude: UILabel!
    
    @IBOutlet weak var speed: UILabel!
    
    @IBOutlet weak var altitude: UILabel!
    
    @IBOutlet weak var steps: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var upstairs: UILabel!
    
    @IBOutlet weak var downstairs: UILabel!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        username = UserDefaults.standard.object(forKey: "GuardianUsername") as? String
        
        if (username == nil) {
            self.performSegue(withIdentifier: "guardianLogin", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let dependentName = UserDefaults.standard.object(forKey: "DependentUsername") as? String
        let dependentName = "8877556633"
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserTable")
        while (true){
            table.read { (result, error) in
                if let err = error {
                    self.displayAlertMessage(useMessage: "Please check you network and try again.")
                    return
                        print("ERROR ", err)
                } else if let items = result?.items {
                    for item in items {
                        if item["id"] as? String == dependentName {
                            self.latitude.text = item["latitude"] as? String
                            self.latitude.text = item["longtitude"] as? String
                            self.speed.text = item["speed"] as? String
                            self.altitude.text = item["altitude"] as? String
                            self.steps.text = item["steps"] as? String
                            self.distance.text = item["distance"] as? String
                            self.upstairs.text = item["upstairs"] as? String
                            self.downstairs.text = item["downstairs"] as? String
                        }
                    }
                }
            }
            let lat = Double(self.latitude.text!)
            let long = Double(self.longtitude.text!)
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, long!)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            map.setRegion(region, animated: true)
            map.isZoomEnabled = true
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "xxx is here"
            map.addAnnotation(annotation)
        }
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlertMessage(useMessage:String){
        let alert = UIAlertController(title:"ALERT",message:useMessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
