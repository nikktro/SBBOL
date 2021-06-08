//
//  ChangeLanguageViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 27.05.2021.
//

import UIKit

class ChangeLanguageViewController: UIViewController {
    
    private let languages = ["English", "Русский", "German"]
    
    var languageTitle: String!
    var languageHandler: ((String) -> ())?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle.title = languageTitle
    }
    

}

extension ChangeLanguageViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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


    // MARK: - IBAction

    @IBAction func closeButtronPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
