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
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var targetLanguageButton: UIButton!
    
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
        sourceLanguageButton.setTitle("English", for: .normal)
        targetLanguageButton.setTitle("Русский", for: .normal)
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func toggleLanguageButton() {
        let sourceLanguage = sourceLanguageButton.titleLabel?.text
        let targetLanguage = targetLanguageButton.titleLabel?.text
        sourceLanguageButton.setTitle(targetLanguage, for: .normal)
        targetLanguageButton.setTitle(sourceLanguage, for: .normal)
        
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
                self?.azure.sourceLanguage = self?.sourceLanguageButton.titleLabel?.text
                self?.azure.targetLanguage = self?.targetLanguageButton.titleLabel?.text
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let changeLanguage = segue.destination as? ChangeLanguageViewController {
            if segue.identifier == "source" {
                changeLanguage.languageTitle = "Source language"
                changeLanguage.languageHandler = { language in
                    self.sourceLanguageButton.setTitle(language, for: .normal)
                    self.azure.sourceLanguage = language
                }
            } else if segue.identifier == "target" {
                changeLanguage.languageTitle = "Target language"
                changeLanguage.languageHandler = { language in
                    self.targetLanguageButton.setTitle(language, for: .normal)
                    self.azure.targetLanguage = language
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
