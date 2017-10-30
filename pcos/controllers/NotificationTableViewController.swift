//
//  NotificationTableViewController.swift
//  wkTest
//
//  Created by MIT.LI on 18/10/17.
//  Copyright © 2017 MIT.LI. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {

    
    
    var messageList: [Any] = []
    override func viewDidLoad() {
        
        getdata()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        super.viewDidLoad()
        

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageList.count
    }

    func getdata()
    {
        let url = URL(string:"http://192.168.1.9:3000/notification")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url:url as! URL)
        request.httpMethod = "Post"
        
        let paramToSend = "patient=1"
        
        request.httpBody = paramToSend.data(using:String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler:{(data,Response,error) in
            guard let _:Data = data else
            {
                return
            }
            do
            {
                print("result is ")
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String:NSArray]
                
                let messageArray = json["message"] as! NSArray
                
                for eachmessage in messageArray {
                    let message = eachmessage as! NSArray
                    self.messageList.append(message[0])
                    
                }
                DispatchQueue.main.async {
                self.tableView.reloadData()
                }
                print(self.messageList.count)

                for mes in self.messageList {
                    print(mes)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = messageList[indexPath.row] as! String
        
        // Configure the cell...

        return cell
    }
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    var msgDetail:String?
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row)selected")
        msgDetail = self.messageList[indexPath.row] as! String
        performSegue(withIdentifier: "detailView", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailView") {
            let vc = segue.destination as! DetailViewController
            vc.data = msgDetail!
            print(vc.data)
            
        }
    }

    
}
