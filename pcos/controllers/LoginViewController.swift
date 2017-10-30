//
//  LoginViewController.swift
//  wkTest
//
//  Created by MIT.LI on 17/10/17.
//  Copyright © 2017 MIT.LI. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleNotification(itemID: 12345)

        //UIApplication.shared.cancelAllLocalNotifications()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        let usrname = username.text
        let psd = password.text
        loginAction(usrname!,psd!)
    }
    
    @IBAction func newUser(_ sender: Any) {
        
       
    }
    
    func scheduleNotification(itemID:Int){
        
        cancelNotification(itemID: itemID)
        
        
        let localNotification = UILocalNotification()
        
        localNotification.fireDate = Date(timeIntervalSinceNow: 10)
        
        localNotification.timeZone = NSTimeZone.default
        
        localNotification.alertBody = "New Notification"
        
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        localNotification.userInfo = ["ItemID":itemID]
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    
    func cancelNotification(itemID:Int){
        
        let existingNotification = self.notificationForThisItem(itemID: itemID)
       if existingNotification != nil {
            
            UIApplication.shared.cancelLocalNotification(existingNotification!)
       }
    }
    
    
    func notificationForThisItem(itemID:Int)-> UILocalNotification? {
        let allNotifications = UIApplication.shared.scheduledLocalNotifications
        for notification in allNotifications! {
            let info = notification.userInfo as! [String:Int]
            let number = info["ItemID"]
            if number != nil && number == itemID {
                return notification as UILocalNotification
            }
        }
        return nil
    }
    

   
    
    
    func loginAction(_ user:String,_ psw:String)
    {
        let url = URL(string:"http://192.168.1.9:3000/authorize")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url:url as! URL)
        request.httpMethod = "POST"
        
        let paramToSend = "username=" + user+"&password="+psw
        
        request.httpBody = paramToSend.data(using:String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler:{(data,Response,error) in
            guard let _:Data = data else
            {
                return
            }
            do
            {
                print("result is ")
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:String]
                
                let curValue = json["message"] as! String
                print(curValue)
                if curValue == "true"
                {
                    DispatchQueue.main.async {
                        
                        let alertController = UIAlertController(
                            title: "Sucessfully",
                            message: "Welcome to use the PCOS system",
                            preferredStyle: UIAlertControllerStyle.alert
                        )
                        let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.default) { (action) in
                            let tab = self.storyboard?.instantiateViewController(withIdentifier: "tab") as! TabBarController
                            tab.email = user
                       
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = tab
                            
                            
                            
                            
                            
                        }
                        alertController.addAction(confirmAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                    
                    
                }
                else
                {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(
                            title: "Failed",
                            message: "Incorrect password or username",
                            preferredStyle: UIAlertControllerStyle.alert
                        )
                        let cancelAction = UIAlertAction(
                            title: "Cancel",
                            style: UIAlertActionStyle.destructive) { (action) in
                                
                        }
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            }
            catch
            {
                print("error is :")
                print(error)
            }
        })
        task.resume()
    }
    
    
    
}
