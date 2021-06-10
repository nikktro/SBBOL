//
//  HistoryCell.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 27.05.2021.
//

import UIKit

final class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var inputTextLabel: UILabel!
    @IBOutlet weak var translatedTextLabel: UILabel!
    
    
    func configure(with translate: Translate) {
        inputTextLabel.text = translate.source
        translatedTextLabel.text = translate.target
    }
    
}
