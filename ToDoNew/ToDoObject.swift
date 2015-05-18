//
//  ToDoObject.swift
//  ToDoNew
//
//  Created by Everett Leo on 5/16/15.
//  Copyright (c) 2015 Everett Leo. All rights reserved.
//

import UIKit

class ToDoObject: NSObject {
    var uid:String
    var desc:String
    
    init(uid: String, desc: String){
        self.uid = uid
        self.desc = desc
    }
}
