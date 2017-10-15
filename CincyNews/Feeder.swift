//
//  Feeder.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/25/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit

class Feeder {
    
    func fetchFeedCategories() -> [FeedCategory]{
        let urlpath     = Bundle.main.path(forResource: "Sources", ofType: "json")
        let url         = NSURL.fileURL(withPath: urlpath!)
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let res = try! decoder.decode(FeedCategoryResponse.self, from: data)
        return res.categories
    }
    
    fileprivate struct FeedCategoryResponse : Codable{
        let categories : [FeedCategory]
    }
    
    func newsFeedItems() -> [FeedItem]
    {
        let feedItems = (fetchFeedCategories().first { (fc) -> Bool in
            return fc.name == "News"
        })!.items
        
        return feedItems
    }
    func sportsFeedItems() -> [FeedItem]
    {
        let feedItems = (fetchFeedCategories().first { (fc) -> Bool in
            return fc.name == "Sports"
        })!.items
        
        return feedItems
    }


}

