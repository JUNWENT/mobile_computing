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
