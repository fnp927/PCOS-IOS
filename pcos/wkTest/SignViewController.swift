//
//  SignViewController.swift
//  wkTest
//
//  Created by MIT.LI on 17/10/17.
//  Copyright © 2017 MIT.LI. All rights reserved.
//

import UIKit
class SignViewController: UIViewController {
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var veryCode: UITextField!
  
    var stringPassed = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func but(_ sender: Any) {
        
        let usrName = mail.text
        let passWord = pass.text
        let verify = veryCode.text
        regisAction(usrName!,passWord!,verify!)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    func regisAction(_ user:String,_ pass:String,_ very:String)
    {
        let url = URL(string:"http://192.168.1.9:3000/verify")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url:url as! URL)
        request.httpMethod = "Post"
        
        let paramToSend = "username=" + user+"&password="+pass+"&verifyCode="+very
        
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
                            message: "Register success",
                            preferredStyle: UIAlertControllerStyle.alert
                        )
                        let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.default) { (action) in
                            let tab = self.storyboard?.instantiateViewController(withIdentifier: "tab") as! UITabBarController
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
                            message: "Incorrect verify code",
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


