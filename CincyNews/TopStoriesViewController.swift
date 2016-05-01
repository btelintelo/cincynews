//
//  TopStoriesViewController.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/19/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit

class TopStoriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! NewsTableViewController
        
        var feedItems = [FeedItem]()
        
        var feedItem = FeedItem()
        feedItem.url = NSURL(string: "http://rssfeeds.cincinnati.com/cincinnati-home")!
        feedItem.source = "cincinnati.com"
        feedItems.append(feedItem)
        
        var feedItem2 = FeedItem()
        feedItem2.url = NSURL(string: "http://www.wlwt.com/13550204?format=rss_2.0&view=feed")!
        feedItem2.source = "wlwt.com"
        feedItems.append(feedItem2)
        vc.feedType = "NEWS"
    
        vc.feedItems = feedItems
    
    }


}
