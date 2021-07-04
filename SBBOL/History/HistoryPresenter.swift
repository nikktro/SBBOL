//
//  HistoryPresenter.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 22.06.2021.
//

import Foundation


protocol HistoryPresenterProtocol: AnyObject {
    var translates: [Translate] { get }
    var translatesCount: Int? { get }
    var fileteredTranslates: [Translate] { get }
    var fileteredTranslatesCount: Int? { get }
    
    func viewWillAppear()
    func translate(atIndex indexPath: IndexPath) -> Translate?
    func filteredTranslate(atIndex indexPath: IndexPath) -> Translate?
    func showTranslateTable(for indexPath: IndexPath)
    func deleteAllData()
    func filterContentForSearchText(_ searchText: String)
}

final class HistoryPresenter {
    weak var view: HistoryViewProtocol!
    var interactor: HistoryInteractorProtocol!
    var router: HistoryRouterProtocol!
    
    var translates: [Translate] = []
    
    var translatesCount: Int? {
        return translates.count
    }
    
    var fileteredTranslates: [Translate] = []
    
    var fileteredTranslatesCount: Int? {
        return fileteredTranslates.count
    }
    
    required init(view: HistoryViewProtocol) {
        self.view = view
    }
}

//MARK: - HistoryPresenterProtocol
extension HistoryPresenter: HistoryPresenterProtocol {
    
    func viewWillAppear() {
        interactor.fetchTranslates()
    }
    
    func translate(atIndex indexPath: IndexPath) -> Translate? {
        if translates.indices.contains(indexPath.row) {
            return translates[indexPath.row]
        } else {
            return nil
        }
    }
        
    func filteredTranslate(atIndex indexPath: IndexPath) -> Translate? {
        if fileteredTranslates.indices.contains(indexPath.row) {
            return fileteredTranslates[indexPath.row]
        } else {
            return nil
        }
    }
    
    func showTranslateTable(for indexPath: IndexPath) {
        if translates.indices.contains(indexPath.row) {
            let traslate = translates[indexPath.row]
            router.openTranslateTableViewController(with: traslate)
        }
    }
    
    func deleteAllData() {
        CoreDataManager.instance.deleteAllData() // TODO: add confirmation
        view.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        fileteredTranslates = translates.filter { (translate: Translate) -> Bool in
            return translate.source?.lowercased().contains(searchText.lowercased()) ?? false
                || translate.target?.lowercased().contains(searchText.lowercased()) ?? false
        }
        view.reloadData()
    }
}

//MARK: - HistoryInteractorOutputProtocol
extension HistoryPresenter: HistoryInteractorOutputProtocol {
    func translatesDidReceive(_ translates: [Translate]) {
        self.translates = translates
        view.reloadData()
    }
}
