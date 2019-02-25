//
//  EntryController.swift
//  JournalCK
//
//  Created by Dominic Lanzillotta on 2/25/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    //MARK: - Singleton
    static let shared = EntryController()
    
    //MARK: - SourceOfTruth
    var entries: [Entry] = []
    
    //MARK: -CRUD
    func createEntryWith(title: String, bodyText: String, completion: @escaping (Bool) -> Void) {
        let entry = Entry(title: title, bodyText: bodyText)
        
        save(entry: entry) { (success) in
            if success == false {
                print("Could not save Entry with title: \(entry.title)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Entry.entryKey, predicate: predicate)
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error saving record to private DB: \(error): \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let records = records else {
                completion(false)
                return
            }
            
            let entries = records.compactMap({ (record) -> Entry? in
                return Entry(record: record)
            })
            self.entries += entries
            completion(true)
        }
    }
    
    func delete(entry: Entry, completion: @escaping (Bool) -> Void) {
        CKContainer.default().privateCloudDatabase.delete(withRecordID: entry.ckRecordID) { (_, error) in
            if let error = error {
                print("Error deleteing record from private Database: \(error): \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let index = self.entries.index(of: entry) else {completion(false); return}
            self.entries.remove(at: index)
            completion(true)
        }
    }
    
    //MARK: - save
    func save(entry: Entry, completion:@escaping (Bool) -> Void) {
        let record = CKRecord(entry: entry)
        CKContainer.default().privateCloudDatabase.save(record) { (savedRecord, error) in
            if let error = error {
                print("Error saving record to private DB: \(error): \(error.localizedDescription)")
                completion(false)
                return
            }
            if let savedRecord = savedRecord {
                let entry = Entry(record: savedRecord)
                if let entry = entry {
                    self.entries.append(entry)
                    completion(true)
                }
            }
        }
    }
}
