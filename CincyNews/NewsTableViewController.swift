
//  NewsTableViewController.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/13/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit
import SafariServices
import MCSwipeTableViewCell

class NewsTableViewController: UITableViewController {

    var newsItems : [NewsItem]?
    var feedItems:[FeedItem]?
    
    var feedType:String!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        
        if self.feedType=="NEWS"{
            feedItems = Feeder().newsFeedItems()
        }
        else if self.feedType=="SPORTS"{
            feedItems = Feeder().sportsFeedItems()
        }
        
        let findAll = FindAllNewsItems()
        findAll.now(feedItems!) { (newsItems) in
            self.newsItems = newsItems
            dispatch_async(dispatch_get_main_queue(),{
                
                self.tableView.reloadData()
                
            })
        }
        
        
        
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

   //  MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = newsItems
        {
            return items.count
        }
        else
        {
            return 0;
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = "newsCell"
//        cellId = "webCell"
//        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as? UITableViewCell{
//            let webView = cell.viewWithTag(10000) as! UIWebView
//            let encodedData = self.newsItems![indexPath.row].description!.dataUsingEncoding(NSUTF8StringEncoding)!
//            let attributedOptions : [String: AnyObject] = [
//                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
//            ]
//            do{
//            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
//                let decodedString = attributedString.string
//                
//                webView.loadHTMLString(decodedString, baseURL: nil)
//            }
// 
//            catch {
//                print(error)
//            }
//            return cell
//        }
        
        if(indexPath.row==0)
        {
            cellId = "primaryCell"
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as? NewsItemTableViewCell
        {
            let item = self.newsItems![indexPath.row]
            
            
            let prefs = NSUserDefaults.standardUserDefaults()
            var list:[String]
            if let obj = prefs.objectForKey("readList")
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
            cell.setSwipeGestureWithView(ci, color: greenColor, mode: MCSwipeTableViewCellMode.Switch, state: MCSwipeTableViewCellState.State1, completionBlock: { (_, _, _) -> Void in
                })
            cell.setSwipeGestureWithView(ci, color: UIColor.greenColor(), mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State2, completionBlock: { (_, _, _) -> Void in
                
                let prefs = NSUserDefaults.standardUserDefaults()
                var list:[String]
                if let obj = prefs.objectForKey("deleteList")
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
                    {}
                    else
                    {
                        list.append(key)
                        prefs.setObject(list, forKey: "deleteList")
                        prefs.synchronize()
                                            }
                    
                }
                self.newsItems?.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
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

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.performSegueWithIdentifier("detailSegue", sender: newsItems![indexPath.row])
        
        let item = newsItems![indexPath.row]
        if let url = NSURL(string: item.link!) {
            
            
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            //presentViewController(vc, animated: true, completion: nil)
            vc.title = item.source
            self.presentViewController(vc, animated: true, completion: { () -> Void in
                
            })
        }

        let prefs = NSUserDefaults.standardUserDefaults()
        var list:[String]
        if let obj = prefs.objectForKey("readList")
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
            {}
            else
            {
                list.append(key)
                prefs.setObject(list, forKey: "readList")
                prefs.synchronize()
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }

        }
        
        
    }
    
     //MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="detailSegue")
        {
            let vc = segue.destinationViewController as! DetailViewController
            vc.newsItem = sender as! NewsItem
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row==0)
        {
            return 240.0
        }
        return 120.0
    }


}
