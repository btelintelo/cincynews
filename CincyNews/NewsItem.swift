//
//  NewsItem.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/13/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import Foundation
import RealmSwift

class NewsItem : Object{

    @objc dynamic var key:String? = nil
    @objc dynamic var title:String? = nil
    @objc dynamic var publishedDate:Date = Date()
    @objc dynamic var descriptionString:String? = nil
    @objc dynamic var descriptionHTML:String? = nil
    @objc dynamic var link:String? = nil
    @objc dynamic var imageUrl:String? = nil
    
    @objc dynamic var source:String? = nil
    
    @objc dynamic var hasRead:Bool = false

}
