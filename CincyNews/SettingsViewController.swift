//
//  SettingsViewController.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/19/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit
import RealmSwift


class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var feedCategories = [FeedCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchFeedCategories()
    }
    
    func fetchFeedCategories(){
        let urlpath     = Bundle.main.path(forResource: "Sources", ofType: "json")
        let url         = NSURL.fileURL(withPath: urlpath!)
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let res = try! decoder.decode(FeedCategoryResponse.self, from: data)
        self.feedCategories = res.categories
        self.tableView.reloadData()
    }
    
    fileprivate struct FeedCategoryResponse : Codable{
        let categories : [FeedCategory]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController : UITableViewDelegate{
    
}
extension SettingsViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedCategories.count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return feedCategories[section - 1].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return feedCategories[section - 1].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "readCell") as! SettingReadTableViewCell
            let realm = try! Realm(configuration: AppDelegate.realmConfig())
            let setting = realm.object(ofType: Settings.self, forPrimaryKey: "1")
            
            if setting?.afterStoryRead == "grey"{
                cell.segmentedControl.selectedSegmentIndex = 0
            }
            else if setting?.afterStoryRead == "remove"{
                cell.segmentedControl.selectedSegmentIndex = 1
            }
            else if setting?.afterStoryRead == "nothing"{
                cell.segmentedControl.selectedSegmentIndex = 2
            }
            return cell
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? SettingFeedTableViewCell{
            let item = feedCategories[indexPath.section - 1].items[indexPath.row]
            cell.title.text = item.source
            let realm = try! Realm(configuration: AppDelegate.realmConfig())
            let setting = realm.object(ofType: Settings.self, forPrimaryKey: "1")
            let selected = setting?.feedKeysStrings().contains(item.key) ?? false
            cell.onOffSwitch.setOn(selected, animated: false)
            cell.key = item.key
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 66.0
        }else{
            return 44.0
        }
    }
}
