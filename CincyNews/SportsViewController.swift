//
//  SportsViewController.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/19/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit

class SportsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let df = DateFormatter()
        df.dateFormat = "MMMM dd"
        self.navigationItem.title = "\(df.string(from: Date())) Sports"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationItem.largeTitleDisplayMode = .always
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! NewsTableViewController
        
        vc.feedType = .sports
        
    }


}
