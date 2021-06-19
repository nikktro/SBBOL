//
//  TranslateTableViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 13.05.2021.
//

import UIKit

final class TranslateTableViewController: UIViewController {
    
    private var textToTranslate: String?
    private var translatedText: String?
    private let coreData = CoreData()
    private let azure = AzureTranslate()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var targetLanguageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        hideKeyboardWhenTappedAround()
        
        coreData.fetchData()
        textToTranslate = (coreData.translates.last?.source) ?? "Enter text to translate"
        translatedText = (coreData.translates.last?.target) ?? "Tap to translate"
        sourceLanguageButton.setTitle("English", for: .normal)
        targetLanguageButton.setTitle("Русский", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coreData.fetchData()
        guard let index = coreData.translates.last?.selectIndex else { return }
        textToTranslate = coreData.translates[Int(index)].source
        translatedText = coreData.translates[Int(index)].target
        sourceLanguageButton.setTitle(coreData.translates[Int(index)].sourceLang, for: .normal)
        targetLanguageButton.setTitle(coreData.translates[Int(index)].targetLang, for: .normal)
        tableView.reloadData()
    }
    
    private func hideKeyboardWhenTappedAround() {
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
            cell.textDidChange { [weak self] (inputed: String) in
                guard let sourceLanguage = self?.sourceLanguageButton.titleLabel?.text else { return }
                guard let targetLanguage = self?.targetLanguageButton.titleLabel?.text else { return }
                self?.azure.getTranslation(for: inputed,
                                           sourceLanguage: sourceLanguage,
                                           targetLanguage: targetLanguage)
                self?.azure.completionHandler = { [weak self] translated in
                    self?.textToTranslate = inputed
                    self?.translatedText = translated
                    self?.coreData.saveData(inputed, translated, sourceLanguage, targetLanguage)
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
                }
            } else if segue.identifier == "target" {
                changeLanguage.languageTitle = "Target language"
                changeLanguage.languageHandler = { language in
                    self.targetLanguageButton.setTitle(language, for: .normal)
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
