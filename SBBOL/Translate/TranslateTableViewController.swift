//
//  TranslateTableViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 13.05.2021.
//

import UIKit

protocol TranslateTableViewProtocol: AnyObject {
    func updateView(with translate: Translate?)
    func updateLanguageBar(sourceLanguage: String, targetLanguage: String)
    func updateTranslate()
}

final class TranslateTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var targetLanguageButton: UIButton!
    
    var presenter: TranslateTablePresenterProtocol!
    
    private let configurator: TranslateTableConfiguratorProtocol = TranslateTableConfigurator()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        presenter.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
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
    
    @IBAction func toggleLanguageButton() {
        presenter.toggleLanguageButton(sourceLanguageButton.currentTitle,
                                       targetLanguageButton.currentTitle)
    }
    
    @IBAction func sourceLanguageButtonPressed(_ sender: UIButton) {
        presenter.changeLanguage(language: sender.currentTitle,
                                 buttonTag: sender.tag)
    }
}

// MARK: - UITableViewDataSource
extension TranslateTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "translate", for: indexPath) as! TranslateTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.textView.text = presenter.textToTranslate
            
            cell.textDidChange { [weak self] (inputText: String) in
                guard let self = self else { return }
                guard let sourceLanguage = self.sourceLanguageButton.titleLabel?.text,
                      let targetLanguage = self.targetLanguageButton.titleLabel?.text
                else { return }
                
                self.presenter.getTranslate(for: inputText,
                                            sourceLanguage: sourceLanguage,
                                            targetLanguage: targetLanguage)
            }
        } else {
            cell.textView.text = presenter.translatedText
        }
                
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TranslateTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK: - TranslateTableViewProtocol
extension TranslateTableViewController: TranslateTableViewProtocol {
    
    func updateView(with translate: Translate?) {
        sourceLanguageButton.setTitle(translate?.sourceLang ?? "English",
                                      for: .normal)
        targetLanguageButton.setTitle(translate?.targetLang ?? "Русский",
                                      for: .normal)
        tableView.reloadData()
    }
    
    func updateLanguageBar(sourceLanguage: String, targetLanguage: String) {
        sourceLanguageButton.setTitle(sourceLanguage, for: .normal)
        targetLanguageButton.setTitle(targetLanguage, for: .normal)
    }
    
    func updateTranslate() {
        tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .automatic)
    }
}


