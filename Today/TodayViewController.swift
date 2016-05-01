//
//  TodayViewController.swift
//  Today
//
//  Created by Brian Telintelo on 4/8/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var headlineLabel: UILabel!
    
    var feedItems:[FeedItem]?
    override func viewDidLoad() {
        super.viewDidLoad()
        headlineLabel.text = "Current Headline"
        // Do any additional setup after loading the view from its nib.
        feedItems = Feeder().newsFeedItems()
        NSLog("Booyah")
        let findAll = FindAllNewsItems()
        findAll.now(feedItems!) { (newsItems) in
            self.headlineLabel.text = "Got Items!"
            if let newsItem = newsItems.first
            {
                dispatch_async(dispatch_get_main_queue(),{
                    
                    
                    self.headlineLabel.text = newsItem.title
                })
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
