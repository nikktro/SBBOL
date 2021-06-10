//
//  HistoryViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 27.05.2021.
//

import UIKit

final class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let refreshControl = UIRefreshControl(frame: .zero)
    @IBOutlet weak var tableView: UITableView!
    
    private let coreData = CoreData()
    private var fileteredCoreData: [Translate] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        hideKeyboardWhenTappedAround()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchController.searchBar
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        tableView.addSubview(refreshControl)
    }
    
    
    private func filterContentForSearchText(_ searchText: String) {
        fileteredCoreData = coreData.translates.filter { (translate: Translate) -> Bool in
            return translate.source?.lowercased().contains(searchText.lowercased()) ?? false
                || translate.target?.lowercased().contains(searchText.lowercased()) ?? false
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreData.fetchData()
        tableView.reloadData()
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
        view.endEditing(true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        coreData.fetchData()
        tableView.reloadData()
        refreshControl.endRefreshing()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "history",
                                                 for: indexPath) as! HistoryCell
        
        if isFiltering {
            translate = fileteredCoreData[indexPath.row]
        } else {
            translate = coreData.translates[indexPath.row]
        }
        
        cell.configure(with: translate)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coreData.translates.last?.selectIndex = Int64(indexPath.row)
        tabBarController?.selectedIndex = 0
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
