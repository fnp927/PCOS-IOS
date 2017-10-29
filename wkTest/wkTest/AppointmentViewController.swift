//
//  AppointmentViewController.swift
//  wkTest
//
//  Created by MIT.LI on 18/10/17.
//  Copyright © 2017 MIT.LI. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController {

    @IBOutlet weak var morn1: UIButton!
    @IBOutlet weak var morn2: UIButton!
    @IBOutlet weak var noon1: UIButton!
    @IBOutlet weak var noon2: UIButton!
    @IBOutlet weak var date: UIDatePicker!
    
    
    var patientID: String = ""
    var clinicID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tab = self.tabBarController as! TabBarController
        
        patientID = tab.patientID
        clinicID = tab.clinicID
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func morn1(_ sender: Any) {
        let date1 = date.date
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        let datestr = format.string(from: date1)
        let message = "The date you want is 9:00-10:00 \(datestr)"
        /*
         let alertController = UIAlertController(title: "Appointment",
         message: message,
         preferredStyle: .alert)
         let confirmAction = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
         alertController.addAction(confirmAction)
         self.present(alertController, animated: true, completion: nil)
         */
        var refreshAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.makeAction(datestr, "MornFirst", self.patientID, self.clinicID)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func morn2(_ sender: Any) {
        let date1 = date.date
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        let datestr = format.string(from: date1)
        let message = "The date you want is 10:00-11:00 \(datestr)"
        
        var refreshAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.makeAction(datestr, "MornSecond", self.patientID, self.clinicID)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func noon1(_ sender: Any) {
        let date1 = date.date
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        let datestr = format.string(from: date1)
        let message = "The date you want is 13:00-14:00 \(datestr)"
        
        var refreshAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.makeAction(datestr, "NoonFirst", self.patientID, self.clinicID)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func noon2(_ sender: Any) {
        let date1 = date.date
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd"
        let datestr = format.string(from: date1)
        let message = "The date you want is 14:00-15:00 \(datestr)"
        var refreshAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.makeAction(datestr, "NoonSecond", self.patientID, self.clinicID)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func makeAction(_ date:String,_ tms:String,_ patient:String, _ clinID:String)
    {
        let url = URL(string:"http://192.168.1.9:3000/appointment")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url:url as! URL)
        request.httpMethod = "POST"
        
        let paramToSend = "clinId="+clinID+"&timeSlot="+tms+"&date="+date+"&patient="+patient
        
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
                            message: "Appointment is registered and the doctor will received an email",
                            preferredStyle: UIAlertControllerStyle.alert
                        )
                        let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.default) { (action) in
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
                            message: "You have to try another time",
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
