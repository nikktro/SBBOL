//
//  HistoryInteractor.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 22.06.2021.
//

import Foundation

protocol HistoryInteractorProtocol: AnyObject {
    func fetchTranslates()
}

protocol HistoryInteractorOutputProtocol: AnyObject {
    func translatesDidReceive(_ translates: [Translate])
}

final class HistoryInteractor {

    unowned var presenter: HistoryInteractorOutputProtocol
    
    init(presenter: HistoryInteractorOutputProtocol) {
        self.presenter = presenter
    }
}

extension HistoryInteractor: HistoryInteractorProtocol {
    func fetchTranslates() {
        CoreDataManager.instance.fetchData { [weak self] translates in
            guard let self = self else { return }
            self.presenter.translatesDidReceive(translates)
        }
    }
}
