//
//  Entry.swift
//  JournalCK
//
//  Created by Dominic Lanzillotta on 2/25/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    var title: String
    var bodyText: String
    let ckRecordID: CKRecord.ID
    
    init(title: String, bodyText: String) {
        self.title = title
        self.bodyText = bodyText
        self.ckRecordID = CKRecord.ID(recordName: UUID().uuidString)
    }
    
    init?(record: CKRecord) {
        guard let title = record[Entry.titleKey] as? String,
        let body = record[Entry.bodyKey] as? String else {return nil}
        
        self.title = title
        self.bodyText = body
        self.ckRecordID = record.recordID
    }
}

extension Entry {
    fileprivate static let titleKey = "Title"
    fileprivate static let bodyKey = "Body"
    fileprivate static let recordIDkey = "ID"
    static let entryKey = "Entry"
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: Entry.entryKey, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: Entry.titleKey)
        self.setValue(entry.bodyText, forKey: Entry.bodyKey)
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}


