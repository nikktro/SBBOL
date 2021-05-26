//
//  TranslateTableViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 13.05.2021.
//

import UIKit

class TranslateTableViewController: UIViewController {

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
        
        //coreData.deleteAllData()
        coreData.fetchData()
        textToTranslate = (coreData.translates.last?.source) ?? "Enter text to translate"
        translatedText = (coreData.translates.last?.target) ?? "Tap to translate"

    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
    
// MARK: - Table view
extension TranslateTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "translate", for: indexPath) as! TranslateTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.textView.text = textToTranslate
            cell.textChanged { [weak self] (inputed: String) in
                self?.azure.getTranslation(for: inputed)
                self?.azure.completionHandler = { [weak self] translated in
                    self?.textToTranslate = inputed
                    self?.translatedText = translated
                    self?.coreData.saveData(inputed, translated)
                    tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .automatic)
                }
            }
        } else {
            cell.textView.text = translatedText
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
