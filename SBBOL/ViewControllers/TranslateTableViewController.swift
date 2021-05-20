//
//  TranslateTableViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 13.05.2021.
//

import UIKit

class TranslateTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var textToTranslate: String?
    var translatedText: String?
    let coreData = CoreData()
    let azure = AzureTranslate()

    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        self.hideKeyboardWhenTappedAround()
        
        coreData.fetchData()
        textToTranslate = coreData.translates.last?.source
        translatedText = coreData.translates.last?.target
        
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "translate", for: indexPath) as! TranslateTableViewCell
        
        cell.textView.tag = indexPath.row
        if cell.textView.tag % 2 == 0 {
            cell.textView.text = textToTranslate
        } else {
            cell.textView.text = translatedText
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
