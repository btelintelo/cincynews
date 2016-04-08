//
//  FindAllNewsItems.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 4/3/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import Foundation

class FindAllNewsItems {
    
    func now(feedItems:[FeedItem], callback: (newsItems: [NewsItem]) -> Void)
    {
        var feedLoadedCount = 0
        var newsItems = [NewsItem]()

            for feed in feedItems
            {
                let parser = RSSParser()
                parser.parseFeedForRequest(NSURLRequest(URL: feed.url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10), source: feed.source, callback: { (myItems, error) -> Void in
                    feedLoadedCount = feedLoadedCount + 1
                    if let e = error
                    {
                        
                    }
                    else
                    {
                        for item in myItems!
                        {
                            if !self.hasDeleted(item)
                            {
                                item.hasRead = self.hasRead(item)
                                newsItems.append(item)
                            }
                            
                        }
                        
                        
                        
                    }
                    print("Feed Loaded Count is \(feedLoadedCount) and total is \(feedItems.count)")
                    if feedLoadedCount == feedItems.count
                    {
                        newsItems = newsItems.sort({ $0.publishedDate.compare($1.publishedDate) == NSComparisonResult.OrderedDescending })
                        
                        callback(newsItems: newsItems)
                        
                    }
                    
                })
        }

        cleanup()
        
        
    }
    
    func hasDeleted(item:NewsItem)->Bool
    {
        if hasKey(item, userDef: "deleteList"){
            return true
        }
        else
        {
            let def = NSUserDefaults.standardUserDefaults()
            var dict:[String: AnyObject]
            if let d = def.dictionaryForKey("settings")
            {
                dict = d
            }
            else{
                dict = [String: AnyObject]()
            }
            
            let readVal = dict["read"]
            if readVal?.description == "remove" {
                return self.hasRead(item)
            }

            return false
        }
        
    }
    
    func hasRead(item:NewsItem)->Bool
    {
        return hasKey(item, userDef: "readList")
    }
    
    func hasKey(item:NewsItem, userDef:String)->Bool
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        var list:[String]
        if let obj = prefs.objectForKey(userDef)
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
    
    func cleanup()
    {
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
    }
  }
