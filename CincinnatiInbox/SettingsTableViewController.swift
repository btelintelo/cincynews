//
//  SettingsTableViewController.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/25/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        initialSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func initialSettings()
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
        
        picker(1000).setOn(boolFor(dict,key: "cincinnati.com-news"), animated: true)
        picker(1100).setOn(boolFor(dict,key: "wlwt.com-news"), animated: true)
        picker(1200).setOn(boolFor(dict,key: "wcpo.com-news"), animated: true)
        picker(1300).setOn(boolFor(dict,key: "fox19.com-news"), animated: true)

        
        /*for val in dict
        {
            val.0
            case 1000:
            dict["cincinnati.com-news"] = picker.on
            case 1100:
            dict["wlwt.com-news"] = picker.on
            case 1200:
            dict["wcpo.com-news"] = picker.on
            case 1300:
            dict["fox19-news"] = picker.on
            case 2000:
            dict["cincinnati.com-sports"] = picker.on
            case 2100:
            dict["wlwt.com-sports"] = picker.on
            case 2200:
            dict["wcpo.com-sports"] = picker.on
            case 2300:
            dict["fox19-sports"] = picker.on
        }*/
    

    }

    @IBOutlet var switches: [UISwitch]!
    
    func picker(tag:Int)->UISwitch
    {
        for sw in switches
        {
            if sw.tag==tag{
                return sw
            }
        }
        return UISwitch()
    }
    
    func boolFor(d:[String:AnyObject],key:String) -> Bool
    {
        var val = d[key] as? Bool
        if let v = val
        {
            if(v)
            {
                return true
            }
        }
        return false
    }
    
    
    
    @IBAction func switchTrigger(sender: AnyObject) {
        let def = NSUserDefaults.standardUserDefaults()
        let picker = sender as! UISwitch
        var dict:[String: AnyObject]
        if let d = def.dictionaryForKey("settings")
        {
            dict = d
        }
        else{
            dict = [String: AnyObject]()
        }
        
        switch picker.tag
        {
        case 1000:
            dict["cincinnati.com-news"] = picker.on
        case 1100:
            dict["wlwt.com-news"] = picker.on
        case 1200:
            dict["wcpo.com-news"] = picker.on
        case 1300:
            dict["fox19.com-news"] = picker.on
        case 2000:
            dict["cincinnati.com-sports"] = picker.on
        case 2100:
            dict["wlwt.com-sports"] = picker.on
        case 2200:
            dict["wcpo.com-sports"] = picker.on
        case 2300:
            dict["fox19.com-sports"] = picker.on
        default: break
           // statements
        }
        
        def.setObject(dict, forKey: "settings")
        def.synchronize()
        
    }

    @IBAction func segmentedControlChange(sender: AnyObject) {
        
        let def = NSUserDefaults.standardUserDefaults()
        let picker = sender as! UISegmentedControl
        var dict:[String: AnyObject]
        if let d = def.dictionaryForKey("settings")
        {
            dict = d
        }
        else{
            dict = [String: AnyObject]()
        }
        
        if picker.selectedSegmentIndex==0
        {
            dict["read"] = "gray"
        }
        else if picker.selectedSegmentIndex==1
        {
            dict["read"] = "remove"
        }
        else if picker.selectedSegmentIndex==2
        {
            dict["read"] = "nothing"
        }
        
        def.setObject(dict, forKey: "settings")
        def.synchronize()

    }

}
