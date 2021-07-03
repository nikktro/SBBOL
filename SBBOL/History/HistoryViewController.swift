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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        presenter.viewDidLoad()
    }

    
    // MARK: - IBAction
    @IBAction func DeleteHistoryData(_ sender: UIBarButtonItem) {
        presenter.deleteAllData()
    }
    
}

// MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.translatesCount ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history",
                                                 for: indexPath) as! HistoryCell
        
        guard let translate = presenter.translate(atIndex: indexPath) else {
            return UITableViewCell()
        }
        
        cell.inputTextLabel.text = translate.source
        cell.translatedTextLabel.text = translate.target
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
