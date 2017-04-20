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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! NewsTableViewController
        
        var feedItems = [FeedItem]()
        
        let feedItem = FeedItem()
        feedItem.url = URL(string: "http://rssfeeds.cincinnati.com/cincinnati-home")!
        feedItem.source = "cincinnati.com"
        feedItems.append(feedItem)
        
        let feedItem2 = FeedItem()
        feedItem2.url = URL(string: "http://www.wlwt.com/13550204?format=rss_2.0&view=feed")!
        feedItem2.source = "wlwt.com"
        feedItems.append(feedItem2)
        vc.feedType = "NEWS"
    
        vc.feedItems = feedItems
    
    }


}
