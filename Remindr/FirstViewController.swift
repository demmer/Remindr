//
//  FirstViewController.swift
//  Remindr
//
//  Created by Michael Demmer on 4/20/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import EventKit
import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: properties
    var watcher: ReminderWatcher = ReminderWatcher.instance();    
    var items: [EKReminder] = [];

    func gotReminders(reminders: [EKReminder]) {
        print("gotReminders", reminders.count)
        self.items = reminders;
        self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
    }
    
    override func viewDidLoad() {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.watcher.watch(self.gotReminders)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        cell?.textLabel?.text = self.items[indexPath.row].title
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

