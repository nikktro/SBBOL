//
//  TranslateTableViewCell.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 16.05.2021.
//

import UIKit

class TranslateTableViewCell: UITableViewCell, UITextViewDelegate {
    
    let azure = AzureTranslate()
    let coreData = CoreData()
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 0 {
            azure.getTranslation(for: textView.text)
            azure.completionHandler = { translatedText in
                self.coreData.saveData(textView.text, translatedText)
                self.coreData.fetchData()
            }
        }
    }

}
