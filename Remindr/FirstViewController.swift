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
    
    var items: [EKReminder] = [];
    var eventStore: EKEventStore = EKEventStore.init();

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEvents()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getEvents()
    }
    
    func getEvents() {
        let calendars = self.eventStore.calendarsForEntityType(EKEntityType.Reminder);
        let remindersPredicate = self.eventStore.predicateForRemindersInCalendars(calendars);
        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted, err) in
            if (!granted) {
                print("access denied");
                return;
            }
            
            self.eventStore.fetchRemindersMatchingPredicate(remindersPredicate, completion: {
                (reminders: [EKReminder]?) in
                self.items.removeAll();
                self.items.appendContentsOf(reminders!);
                self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
            });
        }

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

