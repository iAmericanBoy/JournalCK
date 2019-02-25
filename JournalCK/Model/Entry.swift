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
    let title: String
    let bodyText: String
    let ckRecordID: CKRecord.ID
    
    init(title: String, bodyText: String) {
        self.title = title
        self.bodyText = bodyText
        self.ckRecordID = CKRecord.ID(recordName: UUID().uuidString)
    }
    
    init?(record: CKRecord) {
        guard let title = record[Entry.titleKey] as? String,
        let body = record[Entry.bodyKey] as? String,
            let uuid = record[Entry.recordIDkey] as? CKRecord.ID else {return nil}
        
        self.title = title
        self.bodyText = body
        self.ckRecordID = uuid
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
        self.init(recordType: Entry.entryKey)

        self.setValue(entry.title, forKey: Entry.titleKey)
        self.setValue(entry.bodyText, forKey: Entry.bodyKey)
        self.setValue(entry.ckRecordID, forKey: Entry.recordIDkey)
    }
}


