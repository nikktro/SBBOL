//
//  HistoryViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 27.05.2021.
//

import UIKit

protocol HistoryViewProtocol: AnyObject {
    func reloadData()
}

final class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var presenter: HistoryPresenterProtocol!
    
    private let configurator: HistoryConfiguratorProtocol = HistoryConfigurator()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        tableView.dataSource = self
        tableView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    
    // MARK: - IBAction
    @IBAction func DeleteHistoryData(_ sender: UIBarButtonItem) {
        presenter.deleteAllData()
    }
    
}

// MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return presenter.fileteredTranslatesCount ?? 0
        }
        return presenter.translatesCount ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history",
                                                 for: indexPath) as! HistoryCell
        
        var translate: Translate?
        
        if isFiltering {
            translate = presenter.filteredTranslate(atIndex: indexPath)
        } else {
            translate = presenter.translate(atIndex: indexPath)
        }
        
        guard let translate = translate else {
            return UITableViewCell()
        }
        
        cell.inputTextLabel.text = translate.source
        cell.translatedTextLabel.text = translate.target
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.showTranslateTable(for: indexPath)
    }
}

// MARK: - HistoryViewProtocol
extension HistoryViewController: HistoryViewProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension HistoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        presenter.filterContentForSearchText(searchBar.text ?? "")
    }
}
