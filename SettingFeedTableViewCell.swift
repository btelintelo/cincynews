//
//  SettingFeedTableViewCell.swift
//  Cincy News
//
//  Created by Brian Telintelo on 10/14/17.
//  Copyright © 2017 Brian Telintelo. All rights reserved.
//

import UIKit
import RealmSwift

class SettingFeedTableViewCell: UITableViewCell {

    var key = ""
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func valueChanged(_ sender: Any) {
        let realm = try! Realm(configuration: AppDelegate.realmConfig())
        let setting = realm.object(ofType: Settings.self, forPrimaryKey: "1")
        if let index = setting?.feedKeysStrings().index(of: key), index > -1{
            try! realm.write {
                setting?.feedKeys.remove(at: index)
            }
        }else{
            try! realm.write {
                let rs = RealmString()
                rs.value = key
                setting?.feedKeys.append(rs)
            }
        }
        UserDefaults.standard.removeObject(forKey: "syncTime-\(FeedType.news)")
        UserDefaults.standard.removeObject(forKey: "syncTime-\(FeedType.sports)")
        UserDefaults.standard.synchronize()
    }
}
