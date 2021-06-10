//
//  ChangeLanguageViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 27.05.2021.
//

import UIKit

final class ChangeLanguageViewController: UIViewController {
    
    private let languages = ["English", "Русский", "German"]
    
    var languageTitle: String?
    var languageHandler: ((String) -> ())?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle.title = languageTitle
    }
    
    // MARK: - IBAction
    @IBAction func closeButtronPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension ChangeLanguageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageList", for: indexPath)
        
        cell.textLabel?.text = languages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languages[indexPath.row]
        dismiss(animated: true, completion: { self.languageHandler!(language) } )
    }
    
}
