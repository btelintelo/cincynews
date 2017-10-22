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
    
    func loadFeedFor(_ type:FeedType, callback: @escaping (_ newsItems: [NewsItem]) -> Void){
        reloadIfNeeded(type, callback: callback)
    }
    
    fileprivate func news(callback: @escaping (_ newsItems: [NewsItem]) -> Void){
        let realm = try! Realm(configuration: AppDelegate.realmConfig())
        let setting = realm.object(ofType: Settings.self, forPrimaryKey: "1")
        if let feed = realm.object(ofType: NewsFeed.self, forPrimaryKey: "1"){
            var filteredItems = [NewsItem]()
            for ni in feed.items{
                var skip = false
                if let story = realm.object(ofType: ReadStory.self, forPrimaryKey: ni.key){
                    if story.isDeleted || setting?.afterStoryRead == "remove"{
                        skip = true
                    }
                }
                if !skip {
                    filteredItems.append(ni)
                }
            }
            callback(filteredItems)
//            feed.items.addNotificationBlock({ (change) in
//                callback(feed.items)
//            })
        }
        
        
    }
    
    fileprivate func sports(callback: @escaping (_ newsItems: [NewsItem]) -> Void){
        let realm = try! Realm(configuration: AppDelegate.realmConfig())
        if let feed = realm.object(ofType: SportsFeed.self, forPrimaryKey: "1"){
            var filteredItems = [NewsItem]()
            for ni in feed.items{
                var skip = false
                if let story = realm.object(ofType: ReadStory.self, forPrimaryKey: ni.key){
                    if story.isDeleted{
                        skip = true
                    }
                }
                if !skip {
                    filteredItems.append(ni)
                }
            }
            callback(filteredItems)
            //            feed.items.addNotificationBlock({ (change) in
            //                callback(feed.items)
            //            })
        }
    }
    
    func forceReload(_ type:FeedType, callback: @escaping (_ newsItems: [NewsItem]) -> Void){
        UserDefaults.standard.removeObject(forKey: "syncTime-\(FeedType.news)")
        UserDefaults.standard.removeObject(forKey: "syncTime-\(FeedType.sports)")
        UserDefaults.standard.synchronize()
        reloadIfNeeded(type, callback: callback)
    }
    
    fileprivate func reloadIfNeeded(_ type:FeedType, callback: @escaping (_ newsItems: [NewsItem]) -> Void){
        let now = Date()
        if let lastSync = UserDefaults.standard.object(forKey: "syncTime-\(type)") as? Date{
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .minute, value: 30, to: lastSync) ?? Date()
            if date >= now{
                print("within 30 minutes, no sync")
                if type == .news{
                    news(callback: callback)
                }
                else if type == .sports{
                    sports(callback: callback)
                }
                return
            }else{
                UserDefaults.standard.set(now, forKey: "syncTime-\(type)")
                UserDefaults.standard.synchronize()
            }
        }else{
            UserDefaults.standard.set(now, forKey: "syncTime-\(type)")
            UserDefaults.standard.synchronize()
        }
    
        
        
        let realm = try! Realm(configuration: AppDelegate.realmConfig())
        let setting = realm.object(ofType: Settings.self, forPrimaryKey: "1")
        
        if type == .news{
            let newsItems = Feeder().newsFeedItems()
            let neededNewsItems = newsItems.filter { (fi) -> Bool in
                return setting?.feedKeysStrings().contains(fi.key) ?? false
            }
            if neededNewsItems.count == 0 {
                let news = realm.object(ofType: NewsFeed.self, forPrimaryKey: "1")
                if news != nil {
                    try! realm.write {
                        realm.delete(news!)
                    }
                }
                
            }
            FindAllNewsItems.shared.reload(neededNewsItems) { (newsItems) in
                DispatchQueue.main.async {
                    var news = realm.object(ofType: NewsFeed.self, forPrimaryKey: "1")
                    if news == nil{
                        news = NewsFeed()
                        try! realm.write {
                            realm.add(news!)
                        }
                    }
                    try! realm.write {
                        news?.items.removeAll()
                        news?.items.append(contentsOf: newsItems)
                    }
                    callback(newsItems)
                }
                
            }
        }
        
        if type == .sports{
            let sportsItems = Feeder().sportsFeedItems()
            let neededSportsItems = sportsItems.filter { (fi) -> Bool in
                return setting?.feedKeysStrings().contains(fi.key) ?? false
            }
            if neededSportsItems.count == 0 {
                let news = realm.object(ofType: SportsFeed.self, forPrimaryKey: "1")
                if news != nil {
                    try! realm.write {
                        realm.delete(news!)
                    }
                }
                
            }
            FindAllNewsItems.shared.reload(neededSportsItems) { (newsItems) in
                DispatchQueue.main.async {
                    var news = realm.object(ofType: SportsFeed.self, forPrimaryKey: "1")
                    if news == nil{
                        news = SportsFeed()
                        try! realm.write {
                            realm.add(news!)
                        }
                    }
                    try! realm.write {
                        news?.items.removeAll()
                        news?.items.append(contentsOf: newsItems)
                    }
                    callback(newsItems)
                }
            }
        }
        
    }
    
    fileprivate func reload(_ feedItems:[FeedItem], callback: @escaping (_ newsItems: [NewsItem]) -> Void)
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
