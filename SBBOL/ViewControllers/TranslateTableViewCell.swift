//
//  TranslateTableViewCell.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 16.05.2021.
//

import UIKit

class TranslateTableViewCell: UITableViewCell, UITextViewDelegate {
    
    var textChanged: ((String) -> Void)?
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action: #selector(dismissKeyboard))
        toolbarDone.items = [barBtnDone]
        textView.inputAccessoryView = toolbarDone
        
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textChanged?(textView.text)
    }
        
    @objc func dismissKeyboard() {
        textView.endEditing(true)
    }
    
}
