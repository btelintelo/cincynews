
//  NewsTableViewController.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/13/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit
import SafariServices
import MCSwipeTableViewCell
import RealmSwift
import StoreKit

class NewsTableViewController: UITableViewController {

    var newsItems = [NewsItem]()
    var feedItems:[FeedItem]?
    
    var feedType:FeedType!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(foreground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        self.refreshControl = UIRefreshControl()
       // self.tableView.addSubview(self.refreshControl)
        self.refreshControl?.addTarget(self, action:#selector(refresh), for: UIControlEvents.valueChanged)
    }
    
    @objc func refresh(){
        FindAllNewsItems.shared.forceReload(feedType) { [weak self] (newsItems) in
            self?.newsItems = newsItems
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(NSNotification.Name.UIApplicationWillEnterForeground)
    }
    
    @objc func foreground(){
        loadNews()
    }
    func loadNews(){
        self.refreshControl?.beginRefreshing()
        FindAllNewsItems.shared.loadFeedFor(feedType) { [weak self] (newsItems) in
            self?.newsItems = newsItems
            self?.tableView.reloadData()
            self?.navigationController?.tabBarItem.badgeValue = "\(newsItems.count)"
            self?.refreshControl?.endRefreshing()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNews()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
 
    }

   //  MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellId = "newsCell"
//        cellId = "webCell"
//        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UITableViewCell{
//            let webView = cell.viewWithTag(1000) as! UILabel
//            let descriptionString = self.newsItems[indexPath.row].descriptionHTML ?? ""
//            let data = descriptionString.data(using: .utf8)!
//            let attributedOptions : [NSAttributedString.DocumentReadingOptionKey: Any] = [
//                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
//                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
//            ]
//            do{
//                let attributedString = try NSAttributedString(data: data, options: attributedOptions, documentAttributes: nil)
//                //let decodedString = attributedString.string
//                
//                webView.attributedText = attributedString
//            }
// 
//            catch {
//                print(error)
//            }
//            return cell
//        }
        
//        if((indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 3 || (indexPath as NSIndexPath).row == 6)
//        {
//            cellId = "primaryCell"
//        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? NewsItemTableViewCell
        {
            let item = self.newsItems[(indexPath as NSIndexPath).row]
            
            let realm = try! Realm(configuration: AppDelegate.realmConfig())
            let readList = realm.objects(ReadStory.self)
        
            let list:[String] = readList.map { $0.key }
            
            if let key = item.key
            {
                if(list.contains(key))
                {
                    cell.setNewsItem(item, hasRead: true)
                }
                else
                {
                    cell.setNewsItem(item, hasRead: false)
                }
                
            }
            let ci = UIImageView(image: UIImage(named: "checked-checkbox"))
            let greenColor = UIColor(red: 11, green: 183, blue: 6, alpha: 1)
            cell.secondTrigger = 0.4
            cell.setSwipeGestureWith(ci, color: greenColor, mode: MCSwipeTableViewCellMode.switch, state: MCSwipeTableViewCellState.state1, completionBlock: { (_, _, _) -> Void in
                })
            cell.setSwipeGestureWith(ci, color: UIColor.green, mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state2, completionBlock: { (_, _, _) -> Void in

                if let key = item.key
                {
                    if let story = realm.object(ofType: ReadStory.self, forPrimaryKey: key)
                    {
                        try! realm.write {
                            story.isDeleted = true
                        }
                    }
                    else
                    {
                        try! realm.write {
                            let story = ReadStory()
                            story.isDeleted = true
                            story.key = key
                            realm.add(story)
                        }

                    }
                }
               // self.newsItems.remove(at: indexPath.row)
                
                self.loadNews()

                //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)


            })
            
            
            return cell
            

        }
        
        
        
        

        return UITableViewCell()
    }


    /*
     Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
     Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
             Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
     Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
     Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegueWithIdentifier("detailSegue", sender: newsItems![indexPath.row])
        
        let item = newsItems[(indexPath as NSIndexPath).row]
        if let url = URL(string: item.link!) {
            
            
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            //presentViewController(vc, animated: true, completion: nil)
            vc.title = item.source
            self.present(vc, animated: true, completion: { () -> Void in
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    // Fallback on earlier versions
                }
            })
        }

        let realm = try! Realm(configuration: AppDelegate.realmConfig())
        let readList = realm.objects(ReadStory.self)
        
        var list:[String] = readList.map { $0.key }
        
        if let key = item.key
        {
            if(list.contains(key))
            {}
            else
            {
                let realm = try! Realm(configuration: AppDelegate.realmConfig())
                _ = realm.objects(ReadStory.self)
                
                try! realm.write {
                    let item = ReadStory()
                    item.key = key
                    realm.add(item)
                }
                
                list.append(key)
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }

        }
        
        
    }
    
     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="detailSegue")
        {
            let vc = segue.destination as! DetailViewController
            vc.newsItem = sender as! NewsItem
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if((indexPath as NSIndexPath).row == 0  || (indexPath as NSIndexPath).row == 3 || (indexPath as NSIndexPath).row == 6)
//        {
//            return 240.0
//        }
        return 120.0
    }


}
