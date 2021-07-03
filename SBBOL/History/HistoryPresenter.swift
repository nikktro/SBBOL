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
    
    func viewDidLoad()
    func translate(atIndex indexPath: IndexPath) -> Translate?
    func showTranslateTable(for indexPath: IndexPath)
    func deleteAllData()
}

final class HistoryPresenter {
    weak var view: HistoryViewProtocol!
    var interactor: HistoryInteractorProtocol!
    var router: HistoryRouterProtocol!
    
    var translates: [Translate] = [] {
        didSet {
            view.reloadData()
        }
    }
    
    var translatesCount: Int? {
        return translates.count
    }
    
    required init(view: HistoryViewProtocol) {
        self.view = view
    }
}

//MARK: - HistoryPresenterProtocol
extension HistoryPresenter: HistoryPresenterProtocol {
    
    func viewDidLoad() {
        interactor.fetchTranslates()
    }
    
    func translate(atIndex indexPath: IndexPath) -> Translate? {
        if translates.indices.contains(indexPath.row) {
            return translates[indexPath.row]
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
}

//MARK: - HistoryInteractorOutputProtocol
extension HistoryPresenter: HistoryInteractorOutputProtocol {
    func translatesDidReceive(_ translates: [Translate]) {
        self.translates = translates
        view.reloadData()
    }
}
