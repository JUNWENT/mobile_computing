//
//  DependentLoginViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/23.
//  Copyright © 2017年 Microsoft. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class DependentLoginViewController: UIViewController , UITextFieldDelegate{
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    
    //左手离脑袋的距离
    var offsetLeftHand:CGFloat = 60
    
    //左手图片,右手图片(遮眼睛的)
    var imgLeftHand:UIImageView!
    var imgRightHand:UIImageView!
    
    //左手图片,右手图片(圆形的)
    var imgLeftHandGone:UIImageView!
    var imgRightHandGone:UIImageView!
    
    //登录框状态
    var showType:LoginShowType = LoginShowType.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        
        //猫头鹰头部
        let imgLogin =  UIImageView(frame:CGRect(x: mainSize.width/2-211/2, y: 100, width: 211, height: 109))
        imgLogin.image = UIImage(named:"owl-login")
        imgLogin.layer.masksToBounds = true
        self.view.addSubview(imgLogin)
        
        //猫头鹰左手(遮眼睛的)
        let rectLeftHand = CGRect(x: 61 - offsetLeftHand, y: 90, width: 40, height: 65)
        imgLeftHand = UIImageView(frame:rectLeftHand)
        imgLeftHand.image = UIImage(named:"owl-login-arm-left")
        imgLogin.addSubview(imgLeftHand)
        
        //猫头鹰右手(遮眼睛的)
        let rectRightHand = CGRect(x: imgLogin.frame.size.width / 2 + 60, y: 90, width: 40, height: 65)
        imgRightHand = UIImageView(frame:rectRightHand)
        imgRightHand.image = UIImage(named:"owl-login-arm-right")
        imgLogin.addSubview(imgRightHand)
        
        //登录框背景
        let vLogin =  UIView(frame:CGRect(x: 15, y: 200, width: mainSize.width - 30, height: 160))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        self.view.addSubview(vLogin)
        
        //猫头鹰左手(圆形的)
        let rectLeftHandGone = CGRect(x: mainSize.width / 2 - 100,
                                      y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgLeftHandGone = UIImageView(frame:rectLeftHandGone)
        imgLeftHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgLeftHandGone)
        
        //猫头鹰右手(圆形的)
        let rectRightHandGone = CGRect(x: mainSize.width / 2 + 62,
                                       y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgRightHandGone = UIImageView(frame:rectRightHandGone)
        imgRightHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgRightHandGone)
        
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGray.cgColor
        txtUser.layer.borderWidth = 0.5
        txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser.leftViewMode = UITextFieldViewMode.always
        
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named:"iconfont-user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x: 30, y: 90, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGray.cgColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.isSecureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd.leftViewMode = UITextFieldViewMode.always
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
    }
    
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        //如果当前是用户名输入
        if textField.isEqual(txtUser){
            if (showType != LoginShowType.pass)
            {
                showType = LoginShowType.user
                return
            }
            showType = LoginShowType.user
            
            //播放不遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x - self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y + 30,
                    width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x + 48,
                    y: self.imgRightHand.frame.origin.y + 30,
                    width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x - 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 40, height: 40)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x + 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 40, height: 40)
            })
        }
            //如果当前是密码名输入
        else if textField.isEqual(txtPwd){
            if (showType == LoginShowType.pass)
            {
                showType = LoginShowType.pass
                return
            }
            showType = LoginShowType.pass
            
            //播放遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x + self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y - 30,
                    width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x - 48,
                    y: self.imgRightHand.frame.origin.y - 30,
                    width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x + 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 0, height: 0)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x - 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 0, height: 0)
            })
        }
    }
    
    @IBAction func UserPressedOnSignIn(_ sender: UIButton) {
        let userIdentify = txtUser.text
        let userPassword = txtPwd.text
        let userType = "Dependent"
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserData")
        let tableUser = client.table(withName: "UserTable")
        //let homeController = AddGuardianViewController()
        
        
        
        //check userIdentify is empty
        
        if ((userIdentify?.isEmpty)! || (userPassword?.isEmpty)!){
            self.displayAlertMessage(useMessage: "Your login failed. Please check your username and password, and try again.")
            return;
        }
        
        table.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if(item["type"] as? String == userType){
                        if (item["phoneNumber"] as? String == userIdentify && item["complete"] as! Bool == false){
                            if (item["password"] as? String == userPassword){
                                UserDefaults.standard.set(userIdentify,forKey:"DependentUsername")
                                UserDefaults.standard.synchronize()
                                let itemToInsert = ["id":userIdentify,"complete": false, "__createdAt": Date()] as [String : Any]
                                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                                tableUser.insert(itemToInsert) {
                                    (item, error) in
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    if error != nil {
                                        self.displayAlertMessage(useMessage: "Please check you network and try again.")
                                        print("Error: " + (error! as NSError).description)
                                    }
                                }
                                print("complete checking the user identify and password")
                                let alert = UIAlertController(title:"COMFIRMATION",message:"You have sucessfully sign in.",preferredStyle:UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default){
                                    action in
                                    self.dismiss(animated: true, completion: nil)
                                }
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                self.displayAlertMessage(useMessage: "Your login failed. Please check your username and password, and try again.");
                return;
                
            }
        }
        
        
        
    }
    
    
    
    //display alert message has depulicate
    func displayAlertMessage(useMessage:String){
        
        let alert = UIAlertController(title:"ALERT",message:useMessage,preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil);
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
