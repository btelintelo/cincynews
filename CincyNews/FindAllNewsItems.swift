//
//  FindAllNewsItems.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 4/3/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import Foundation
import RealmSwift

class FindAllNewsItems {
    
    static let shared = FindAllNewsItems()
    
    func news(callback: @escaping (_ newsItems: List<NewsItem>) -> Void){
        let realm = try! Realm(configuration: AppDelegate.realmConfig())
        if let feed = realm.object(ofType: NewsFeed.self, forPrimaryKey: "1"){
            callback(feed.items)
            feed.addNotificationBlock({ (change) in
                callback(feed.items)
            })
        }
        
        
    }
    
    func sports(callback: @escaping (_ newsItems: List<NewsItem>) -> Void){
        let realm = try! Realm(configuration: AppDelegate.realmConfig())
        if let feed = realm.object(ofType: SportsFeed.self, forPrimaryKey: "1"){
            callback(feed.items)
            feed.addNotificationBlock({ (change) in
                callback(feed.items)
            })
        }
    }
    
    func reload(_ feedItems:[FeedItem], callback: @escaping (_ newsItems: [NewsItem]) -> Void)
    {
        var feedLoadedCount = 0
        var newsItems = [NewsItem]()

            for feed in feedItems
            {
                let parser = RSSParser()
                parser.parseFeedForRequest(URLRequest(url: feed.url(), cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10), source: feed.source, callback: { (myItems, error) -> Void in
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
                                item.hasRead = self.hasRead(item)
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
        if hasKey(item){
            let readStory = keyForItem(item)
            return readStory!.isDeleted
        }
        else
        {
            let realm = try! Realm(configuration: AppDelegate.realmConfig())
            let setting = realm.object(ofType: Settings.self, forPrimaryKey: "1")
            if setting?.afterStoryRead == "remove" {
                return self.hasRead(item)
            }
            return false
        }
        
    }
    
    func hasRead(_ item:NewsItem)->Bool
    {
        return hasKey(item)
    }
    
    func keyForItem(_ item:NewsItem) -> ReadStory?{
        let realm = try! Realm(configuration: AppDelegate.realmConfig())
        let readList = realm.objects(ReadStory.self)
        return readList.first(where: { (rs) -> Bool in
            return rs.key == item.key
        })
    }
    
    func hasKey(_ item:NewsItem)->Bool
    {
        if let readList = keyForItem(item){
            return true
        }
        
        return false

    }
  }
