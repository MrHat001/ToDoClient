//
//  MainTableViewController.swift
//  ToDoNew
//
//  Created by Everett Leo on 5/16/15.
//  Copyright (c) 2015 Everett Leo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainTableViewController: UITableViewController {

    let ServerURL = "https://todoapp-webversion.herokuapp.com"
    var ToDoDescToMake: String = ""
    //var jsonArray:NSDictionary = NSDictionary()
    var todos = [ToDoObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        loadJSONfromServer()
    }
    
    func loadJSONfromServer(){
        self.todos = [ToDoObject]()
        Alamofire.request(.GET, ServerURL + "/iostodo").responseJSON(){
            (req, res, data, err) in
            //println(data!)
            let jsonData:NSArray =  data!["todos"] as! NSArray
            //println(jsonData)
            for d in jsonData{
                var desc:String = d["desc"] as! String
                var uid:String = d["uid"] as! String
                
                let newToDoObject = ToDoObject(uid: uid, desc: desc)
                self.todos.append(newToDoObject)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func cancelSegueToMainView(unwindSegue: UIStoryboardSegue){
        ToDoDescToMake = ""
    }
    
    @IBAction func doneSegueToMainView(unwindSegue: UIStoryboardSegue){
        //create data and send to server
        Alamofire.request(.POST, ServerURL + "/iostodo", parameters: ["desc": ToDoDescToMake]).responseJSON(){
            (req, res, data, err) in
            //println(req)
            //println(res)
            println(data)
            if(data!["redirect"] as? String != "/iostodo"){
                let alertController = UIAlertController(title: "Error", message: data!["error"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion:nil)
            }
            //println(err)
            
            self.loadJSONfromServer()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return todos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        var cell = UITableViewCell()
        for(var i = 0; i < self.todos.count; i++){
            if(indexPath == NSIndexPath(forRow: i, inSection: 0)){
                cell.textLabel!.text = self.todos[i].desc
            }
        }

        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            for(var i = 0; i < self.todos.count; i++){
                if(i == indexPath.row){
                    let id = self.todos[i].uid
                    Alamofire.request(.GET, ServerURL + "/iosdelete?uid=" + id).responseJSON(){
                        (req, res, data, err) in
                        println(err)
                        if(data!["redirect"] as? String != "/iostodo"){
                            let alertController = UIAlertController(title: "Error", message: data!["error"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                            let defaultAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.presentViewController(alertController, animated: true, completion:nil)
                        }
                        
                        self.loadJSONfromServer()
                    }
                }
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
