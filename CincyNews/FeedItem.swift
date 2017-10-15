//
//  FeedItem.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/19/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit
//import RealmSwift
//
//class FeedItem : Object {
//
//    @objc dynamic var urlString:String = ""
//    @objc dynamic var source:String = ""
//
//    func url() -> URL{
//        return URL(string: urlString)!
//    }
//
//}


struct FeedItem : Codable{
    
    let key : String
    let urlString:String
    let source:String
    
    func url() -> URL{
        return URL(string: urlString)!
    }
}

