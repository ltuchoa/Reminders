//
//  AddViewController.swift
//  Reminders
//
//  Created by Larissa Uchoa on 30/04/20.
//  Copyright © 2020 Larissa Uchoa. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    
    @IBOutlet var bodyField: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        
        titleField.autocorrectionType = .no
        bodyField.autocorrectionType = .no
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSaveButton))
        
        navigationItem.backBarButtonItem?.tintColor = .magenta
        navigationItem.rightBarButtonItem?.tintColor = .magenta
    }
    
    @objc func didTapSaveButton() {
        if let titleText = titleField.text, !titleText.isEmpty,
            let bodyText = bodyField.text, !bodyText.isEmpty {
            
            let targetDate = datePicker.date
            
            completion?(titleText, bodyText, targetDate)
            
        }
    }

}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
