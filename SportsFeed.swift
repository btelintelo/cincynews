//
//  SportsFeed.swift
//  Cincy News
//
//  Created by Brian Telintelo on 10/14/17.
//  Copyright © 2017 Brian Telintelo. All rights reserved.
//

import Foundation
import RealmSwift


class SportsFeed:Object{
    
    var items = List<NewsItem> ()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var id : String = "1"
}
