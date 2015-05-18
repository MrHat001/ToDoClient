//
//  SignupViewController.swift
//  ToDoNew
//
//  Created by Everett Leo on 5/16/15.
//  Copyright (c) 2015 Everett Leo. All rights reserved.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {

    let ServerURL: String = "https://todoapp-webversion.herokuapp.com"
    let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.secureTextEntry = true
        repeatPasswordField.secureTextEntry = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignupTouched(sender: AnyObject) {
        if(usernameField.text.isEmpty || passwordField.text.isEmpty || repeatPasswordField.text.isEmpty){
            let alertController = UIAlertController(title: "Error", message: "You need to fill out every field", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else if(passwordField.text != repeatPasswordField.text){
            let alertController = UIAlertController(title: "Error", message: "The Passwords must match", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            //Send Sign up request to the Server
            Alamofire.request(.POST, ServerURL + "/signup", parameters: ["username": usernameField.text, "pass": passwordField.text, "pass2": repeatPasswordField.text]).responseJSON(){
                (req, res, data, error) in
                /*self.cookieJar.cookiesForURL(NSURL(string:"https://todoapp-webversion.herokuapp.com/cookies")!)
                
                var biscuits:[NSHTTPCookie] = self.cookieJar.cookies as! [NSHTTPCookie]
                for cookie:NSHTTPCookie in biscuits as [NSHTTPCookie]{
                    if cookie.name as String == "connect.sid"{
                        self.AccountID = cookie.value! as String
                    }
                }*/
                
                //println(data)
                if(data!["redirect"] as? String != "/todo"){
                    let alertController = UIAlertController(title: "Error", message: data!["error"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    let defaultAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion:nil)
                } else {
                    self.performSegueWithIdentifier("SignupSegue", sender: nil)
                }
            }
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
