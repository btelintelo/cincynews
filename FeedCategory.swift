//
//  FeedCategory.swift
//  Cincy News
//
//  Created by Brian Telintelo on 10/14/17.
//  Copyright © 2017 Brian Telintelo. All rights reserved.
//

import Foundation
import RealmSwift

//class FeedCategory: Object, Codable{
//
//    @objc dynamic var name : String = ""
//
//    var items = List<FeedItem> ()
//}



struct FeedCategory : Codable{
    let name : String
    let items : [FeedItem]
}
