//
//  MainViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/10/5.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var username:String?
    
    override func viewDidAppear(_ animated: Bool) {
        username = UserDefaults.standard.object(forKey: "Username") as? String
        if( username != nil){
            self.performSegue(withIdentifier: "In", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let mainSize = UIScreen.main.bounds.size
        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "main3-iloveimg-cropped", withExtension: "gif")!)
        let advTimeGif = UIImage.gif(data: imageData)
        let loadingImage = UIImageView(image:advTimeGif)
        loadingImage.frame = CGRect (x: mainSize.width/4, y: 200.0, width: mainSize.width/2, height: mainSize.height/4)
        
        //CGRect()
        
        view.addSubview(loadingImage)
        
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
