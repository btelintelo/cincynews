//
//  ReadStory.swift
//  Cincy News
//
//  Created by Brian Telintelo on 10/14/17.
//  Copyright © 2017 Brian Telintelo. All rights reserved.
//

import Foundation
import RealmSwift

class ReadStory : Object{
    @objc dynamic var key = ""
    @objc dynamic var isDeleted = false
    
     override class func primaryKey() -> String?{
        return "key"
    }
}
