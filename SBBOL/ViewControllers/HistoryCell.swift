//
//  HistoryCell.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 27.05.2021.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var inputTextLabel: UILabel!
    @IBOutlet weak var translatedTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with translate: Translate) {
        inputTextLabel.text = translate.source
        translatedTextLabel.text = translate.target
    }

}
