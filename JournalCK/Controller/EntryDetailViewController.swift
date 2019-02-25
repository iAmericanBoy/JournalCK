//
//  EntryDetailViewController.swift
//  JournalCK
//
//  Created by Dominic Lanzillotta on 2/25/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var bodyTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    //MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
        let body = bodyTextField.text, !body.isEmpty else {return}
        
        if let entry = entry {
            //update
            self.navigationController?.popViewController(animated: true)

        } else {
            //new Entry
            EntryController.shared.createEntryWith(title: title, bodyText: body) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    //MARK: - Private Functions
    func updateViews() {
        guard let entry = entry else {return}
        self.title = "Entry"
        
        self.titleTextField.text = entry.title
        self.bodyTextField.text = entry.bodyText
        
    }
}
