//
//  HistoryViewController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 27.05.2021.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let coreData = CoreData()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.hideKeyboardWhenTappedAround()
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
        return coreData.translates.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as! HistoryCell
        
        cell.configure(with: coreData.translates[indexPath.row])
        
        return cell
    }
    
    
// MARK: - IBAction
        
    @IBAction func DeleteHistoryData(_ sender: UIBarButtonItem) {
        coreData.deleteAllData()
        coreData.fetchData()
        tableView.reloadData()
    }
    
    
}
