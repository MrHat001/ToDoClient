//
//  AddToDoViewController.swift
//  ToDoNew
//
//  Created by Everett Leo on 5/16/15.
//  Copyright (c) 2015 Everett Leo. All rights reserved.
//

import UIKit

class AddToDoViewController: UITableViewController {

    @IBOutlet weak var ToDoDescField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueView = segue.destinationViewController as! MainTableViewController
        
        segueView.ToDoDescToMake = ToDoDescField.text
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
