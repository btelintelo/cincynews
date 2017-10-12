//
//  Feeder.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/25/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit

class Feeder {
    
    func newsFeedItems() -> [FeedItem]
    {
        var feedItems = [FeedItem]()
        
        
        let def = UserDefaults.standard
        var dict:[String: Any]
        if let d = def.dictionary(forKey: "settings")
        {
            dict = d
        }
        else{
            dict = [String: AnyObject]()
        }
        
        
        if let bool = dict["cincinnati.com-news"] as? Bool{
            if bool{
                feedItems.append(feedFor(cincinnatiNews, source: "cincinnati.com"))
            }
        }
        if let bool = dict["wlwt.com-news"] as? Bool{
            if bool{
                feedItems.append(feedFor(wlwtNews, source: "wlwt.com"))
            }
        }
        if let bool = dict["wcpo.com-news"] as? Bool{
            if bool{
                feedItems.append(feedFor(wcpoNews, source: "wcpo.com"))
            }
        }
        if let bool = dict["fox19.com-news"] as? Bool{
            if bool{
                feedItems.append(feedFor(fox19News, source: "fox19.com"))
            }
        }
        if let bool = dict["bizjournals.com-news"] as? Bool{
            if bool{
                feedItems.append(feedFor(bizJournalsNews, source: "bizjournals.com"))
            }
        }
        
        
        return feedItems
    }
    func sportsFeedItems() -> [FeedItem]
    {
        var feedItems = [FeedItem]()
        
        
        let def = UserDefaults.standard
        var dict:[String: Any]
        if let d = def.dictionary(forKey: "settings")
        {
            dict = d
        }
        else{
            dict = [String: AnyObject]()
        }
        
        
        if let bool = dict["cincinnati.com-sports"] as? Bool{
            if bool{
                feedItems.append(feedFor(cincinnatiSports, source: "cincinnati.com"))
            }
        }
//        if let bool = dict["wlwt.com-sports"] as? Bool{
//            if bool{
//                feedItems.append(feedFor(wlwtSports, source: "wlwt.com"))
//            }
//        }
        if let bool = dict["wcpo.com-sports"] as? Bool{
            if bool{
                feedItems.append(feedFor(wcpoSports, source: "wcpo.com"))
            }
        }
        if let bool = dict["fox19.com-sports"] as? Bool{
            if bool{
                feedItems.append(feedFor(fox19Sports, source: "fox19.com"))
            }
        }
        
        
        return feedItems
    }

    
    func feedFor(_ url:String, source:String)->FeedItem
    {
        let feed = FeedItem()
        feed.url = URL(string: url)
        feed.source = source
        return feed
    }
    
    let cincinnatiNews = "http://rssfeeds.cincinnati.com/cincinnati-home"
    let fox19News = "http://www.fox19.com/global/Category.asp?c=55035&clienttype=rss"
    let wlwtNews = "http://www.wlwt.com/topstories-rss"
    let wcpoNews = "http://www.wcpo.com/feeds/rssFeed?obfType=RSS_FEED&siteId=10015&categoryId=10001"
    let bizJournalsNews="http://feeds.bizjournals.com/bizj_cincinnati"
    
    let cincinnatiSports = "http://rssfeeds.cincinnati.com/cincinnati-sports"
    let fox19Sports = "http://www.fox19.com/global/Category.asp?c=4219&clienttype=rss"
    //let wlwtSports = "http://www.wlwt.com/9838852?format=rss_2.0&view=feed"
    let wcpoSports = "http://www.wcpo.com/feeds/rssFeed?obfType=RSS_FEED&siteId=10015&categoryId=10004"

}
