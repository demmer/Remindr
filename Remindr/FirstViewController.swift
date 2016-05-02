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
        let eventsPredicate = self.eventStore.predicateForEventsWithStartDate(
            NSDate.distantPast(), endDate: NSDate.distantFuture(), calendars: calendars);
        let remindersPredicate = self.eventStore.predicateForRemindersInCalendars(calendars);
        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted, err) in
            if (!granted) {
                print("access denied");
                return;
            }
            
            let events = self.eventStore.fetchRemindersMatchingPredicate(remindersPredicate, completion: {
                (reminders: [EKReminder]?) in
                print("got reminders", reminders!.count)
                self.items.removeAll();
                self.items.appendContentsOf(reminders!);
                self.tableView.reloadData()
            });
        }
        self.eventStore.requestAccessToEntityType(EKEntityType.Event) { (granted, err) in
            print("event access granted", granted, err);
        }
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count", self.items.count)
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        
        cell?.textLabel?.text = self.items[indexPath.row].title
        
        print("cell", indexPath, cell?.textLabel?.text)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }


}

