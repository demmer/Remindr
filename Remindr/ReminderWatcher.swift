//
//  ReminderWatcher.swift
//  Remindr
//
//  Created by Michael Demmer on 5/3/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import EventKit

class ReminderWatcher {
    var eventStore: EKEventStore = EKEventStore.init();
    var watchers: [([EKReminder]) -> ()] = [];
    var items: [EKReminder] = [];
    
    init() {
        print("ReminderWatcher init");
    }
    
    func watch(callback: ([EKReminder]) -> ()) {
        print("ReminderWatcher adding watcher")
        watchers.append(callback);
        if (watchers.count == 1) {
            self.startWatching();
            //self.getEvents();
        }
    }

    func notify() {
        print("ReminderWatcher notify", self.items.count)
        for (watcher) in watchers {
            watcher(self.items);
        }
    }

    func startWatching() {
        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted, err) in
            if (!granted) {
                print("access denied");
                return;
            }
            print("Adding observer")
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(self.getEvents),
                                                             name: EKEventStoreChangedNotification,
                                                             object: self.eventStore)
            self.getEvents()
        }
    }
    
    @objc func getEvents() {
        let calendars = self.eventStore.calendarsForEntityType(EKEntityType.Reminder);
        let remindersPredicate = self.eventStore.predicateForRemindersInCalendars(calendars);
        
        print("ReminderWatcher getEvents")
        self.eventStore.fetchRemindersMatchingPredicate(remindersPredicate, completion: {
            (reminders: [EKReminder]?) in
            print("ReminderWatcher getEvents got", reminders?.count, "reminders")
            self.items.removeAll();
            let active = reminders?.filter({ (reminder) in return !reminder.completed; })
            self.items.appendContentsOf(active!);
            self.notify();
        });
    }
    

    static func instance() -> ReminderWatcher {
        print("ReminderWatcher getting instance");
        struct Singleton {
            static let instance = ReminderWatcher()
        }
        return Singleton.instance;
    }
    
    
}

