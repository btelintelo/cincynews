//
//  Settings.swift
//  Cincy News
//
//  Created by Brian Telintelo on 10/14/17.
//  Copyright © 2017 Brian Telintelo. All rights reserved.
//

import Foundation
import RealmSwift

class Settings : Object{
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var id : String = "1"
    
    @objc dynamic var afterStoryRead : String = ""
    
    var feedKeys = List<RealmString> ()

    func feedKeysStrings() -> [String]{
        return Array(feedKeys.map { $0.value })
    }
}

class RealmString : Object {
    @objc dynamic var value = ""
}
