//
//  LoginViewController.swift
//  ToDoNew
//
//  Created by Everett Leo on 5/16/15.
//  Copyright (c) 2015 Everett Leo. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    let ServerURL: String = "https://todoapp-webversion.herokuapp.com"
    let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.secureTextEntry = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        passwordField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginTapped(sender: AnyObject) {
        if(usernameField.text.isEmpty || passwordField.text.isEmpty){
            let alertController = UIAlertController(title: "Error", message: "You need to input both an username and password", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            //check that the credentials are correct
            Alamofire.request(.POST, ServerURL + "/login", parameters:["username": usernameField.text, "pass": passwordField.text]).responseJSON(){
                (req, res, data, error) in
                //println(self.cookieJar.cookiesForURL(NSURL(string:"https://todoapp-webversion.herokuapp.com/cookies")!))
                /*self.cookieJar.cookiesForURL(NSURL(string:"https://todoapp-webversion.herokuapp.com/cookies")!)
                //println(res)
                //println(self.cookieJar.cookies)
                var biscuits:[NSHTTPCookie] = self.cookieJar.cookies as! [NSHTTPCookie]
                for cookie:NSHTTPCookie in biscuits as [NSHTTPCookie]{
                    if cookie.name as String == "connect.sid"{
                        self.AccountID = cookie.value! as String
                    }
                }*/
                //println(data!)
                //println(error)
                if(data!["redirect"] as? String != "/todo"){
                    let alertController = UIAlertController(title: "Error", message: data!["error"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    let defaultAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion:nil)
                } else {
                    self.performSegueWithIdentifier("LoginSegue", sender: nil)
                }
                
                //println(self.AccountID)
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func unwindSegueToLogin(unwindSegue: UIStoryboardSegue){
        if let mainViewController = unwindSegue.sourceViewController as? MainTableViewController {
            //Sign out code
            Alamofire.request(.GET, ServerURL + "/logout")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
