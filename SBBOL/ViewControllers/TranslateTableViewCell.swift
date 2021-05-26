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
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textChanged?(textView.text)
    }
    
}
