//
//  InfoViewController.swift
//  wkTest
//
//  Created by MIT.LI on 19/10/17.
//  Copyright © 2017 MIT.LI. All rights reserved.
//

import UIKit
import Foundation

class InfoViewController: UIViewController {
    @IBOutlet weak var centerID: UILabel!
    @IBOutlet weak var centerName: UILabel!
    @IBOutlet weak var clinicianEmail: UILabel!
    @IBOutlet weak var clinicianID: UILabel!
    @IBOutlet weak var clinicianName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var patientID: UILabel!
    
   
    
    var patID:String = ""
    var clinicID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tab = self.tabBarController as! TabBarController
        
        let user = tab.email
        
        getInfo(user, "ef3b5d02")
        
        
        
      
        
      

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
    
    func getInfo(_ userEmail:String,_ verifyCode:String)
    {
        let url = URL(string:"http://192.168.1.9:9000/pcos/api/verify")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url:url as! URL)
        request.httpMethod = "POST"
        let parameters = [
            "email": userEmail,
            "mobileVerification": verifyCode
            ] as [String : Any]
        
        print(parameters)
        
        //let paramToSend = "email=" + userEmail + "&mobileVerification=" + verifyCode
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "6b0f3655-ecdc-e9e4-ac27-0d0efe4884f1"
        ]
       
        do {
         let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        //request.httpBody = paramToSend.data(using:String.Encoding.utf8)
        request.httpBody = postData as Data
    }
    catch
    {
    print("error is :")
    print(error)
    }
        let task = session.dataTask(with: request as URLRequest, completionHandler:{(data,Response,error) in
            guard let _:Data = data else
            {
                return
            }
            do
            {
                print("result is ")
              let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String:Any]
                let target = json["profile"] as? [String: Any]
                DispatchQueue.main.async {
                    let tab = self.tabBarController as! TabBarController
                    self.centerID.text = "\(target!["centerId"] as! Int)"
                    self.clinicianID.text = "\(target!["clinicianId"] as! Int)"
                    self.patientID.text = "\(target!["patientId"] as! Int)"
                   
                  
                    self.patID = "\(target!["patientId"] as! Int)"
                    
                    tab.patientID = self.patID
                    tab.clinicID = "\(target!["clinicianId"] as! Int)"
                    self.centerName.text  = target!["centerName"] as! String
                    self.email.text  = target!["email"] as! String
                    self.clinicianName.text  = target!["clinicianName"] as! String
                    self.clinicianEmail.text  = target!["clinicianEmail"] as! String
                    

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
