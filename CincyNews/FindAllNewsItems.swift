//
//  FindAllNewsItems.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 4/3/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import Foundation
import Firebase

class FindAllNewsItems {
    
    func now(_ feedItems:[FeedItem], callback: @escaping (_ newsItems: [NewsItem]) -> Void)
    {
        var feedLoadedCount = 0
        var newsItems = [NewsItem]()

            for feed in feedItems
            {
                let parser = RSSParser()
                parser.parseFeedForRequest(URLRequest(url: feed.url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10), source: feed.source, callback: { (myItems, error) -> Void in
                    feedLoadedCount = feedLoadedCount + 1
                    if error != nil
                    {
                        
                    }
                    else
                    {
                        for item in myItems!
                        {
                            if !self.hasDeleted(item)
                            {
                                //item.hasRead = self.hasRead(item)
                                newsItems.append(item)
                            }
                            
                        }
                        
                        
                        
                    }
                    print("Feed Loaded Count is \(feedLoadedCount) and total is \(feedItems.count)")
                    if feedLoadedCount == feedItems.count
                    {
                        newsItems = newsItems.sorted(by: { $0.publishedDate.compare($1.publishedDate) == ComparisonResult.orderedDescending })
                        
                        callback(newsItems)
                        
                    }
                    
                })
        }

       // cleanup()
        
        
    }
    
    func hasDeleted(_ item:NewsItem)->Bool
    {
        if hasKey(item, userDef: "deleteList"){
            return true
        }
        else
        {
            let def = UserDefaults.standard
            var dict:[String: Any]
            if let d = def.dictionary(forKey: "settings")
            {
                dict = d
            }
            else{
                dict = [String: Any]()
            }
            
            if let readVal = dict["read"] as? String{
                if readVal == "remove" {
                    return self.hasRead(item)
                }
            }
            

            return false
        }
        
    }
    
    func hasRead(_ item:NewsItem)->Bool
    {
        return hasKey(item, userDef: "readList")
    }
    
    func hasKey(_ item:NewsItem, userDef:String)->Bool
    {
        let prefs = UserDefaults.standard
        var list:[String]
        if let obj = prefs.object(forKey: userDef)
        {
            list = obj as! [String]
        }
        else
        {
            list = [String]()
        }
        if let key = item.key
        {
            if(list.contains(key))
            {
               return true
            }
            else
            {
                return false
            }
            
        }
        return false

    }
    
//    func cleanup()
//    {
//        let prefs = NSUserDefaults.standardUserDefaults()
//        let sevenDaysAgo = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -7,
//                                                                         toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
//        if let items = prefs.objectForKey("readList") as? [NewsItem]
//        {
//            var deleteMe = items
//            for item in items
//            {
//                if item.publishedDate.compare(sevenDaysAgo) == NSComparisonResult.OrderedAscending
//                {
//                    //remove
//                    
//                }
//            }
//        }
//    }
  }
