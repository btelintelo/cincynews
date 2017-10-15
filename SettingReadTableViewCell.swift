//
//  SettingReadTableViewCell.swift
//  Cincy News
//
//  Created by Brian Telintelo on 10/14/17.
//  Copyright © 2017 Brian Telintelo. All rights reserved.
//

import UIKit
import RealmSwift

class SettingReadTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        var readMode : String?
        if segmentedControl.selectedSegmentIndex==0
        {
            readMode = "gray"
        }else if segmentedControl.selectedSegmentIndex==1
        {
            readMode = "remove"
        }else if segmentedControl.selectedSegmentIndex==2
        {
           readMode = "nothing"
        }
        
        if let mode = readMode{
            let realm = try! Realm(configuration: AppDelegate.realmConfig())
            let setting = realm.object(ofType: Settings.self, forPrimaryKey: "1")
            try! realm.write {
                setting?.afterStoryRead = mode
            }
        }
    }
    

    
}
