//
//  HistoryViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 27.05.2021.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let coreData = CoreData()
    var fileteredCoreData: [Translate] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        fileteredCoreData = coreData.translates.filter { (translate: Translate) -> Bool in
            return translate.source?.lowercased().contains(searchText.lowercased()) ?? false || translate.target?.lowercased().contains(searchText.lowercased()) ?? false
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreData.fetchData()
        tableView.reloadData()
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
        if isFiltering {
          return fileteredCoreData.count
        }
        return coreData.translates.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let translate: Translate
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as! HistoryCell
                
        if isFiltering {
            translate = fileteredCoreData[indexPath.row]
        } else {
            translate = coreData.translates[indexPath.row]
        }
        
        cell.configure(with: translate)
        
        return cell
    }
    
    
// MARK: - IBAction
        
    @IBAction func DeleteHistoryData(_ sender: UIBarButtonItem) {
        coreData.deleteAllData()
        coreData.fetchData()
        tableView.reloadData()
    }
    
    
}

// MARK: - SearchBar
extension HistoryViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text ?? "")
  }
}
