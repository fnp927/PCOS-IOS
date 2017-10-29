//
//  ViewController.swift
//  wkTest
//
//  Created by MIT.LI on 30/9/17.
//  Copyright © 2017 MIT.LI. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var wbview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getCookie()
    }
    
    
    
    //func getCookie(completion: @escaping (_ result:[HTTPCookie]) -> ()) {
    func getCookie(){
        let parameters : Parameters = [
            "username":"22214126@163.com",
            "password":"wcc"
        ]
        let url = URL(string:"http://192.168.1.9:9000/pcos/patient/1/patientquestionnaire/new")
        Alamofire.request("http://192.168.1.9:9000/pcos/login", method: HTTPMethod.post, parameters: parameters).responseData { (responseObject) -> Void in
            if let responseStatus = responseObject.response?.statusCode {
                print(responseStatus)
                if responseStatus != 200 {
                    // error
                } else {
                    // view all cookies
                    var req = URLRequest(url: url!)
                    req.httpMethod="GET"
                    self.wbview.frame = self.view.bounds
                    self.wbview.scalesPageToFit = true
                    self.wbview.loadRequest(req)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

