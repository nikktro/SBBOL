//
//  HistoryConfigurator.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 22.06.2021.
//

import Foundation

protocol HistoryConfiguratorProtocol: AnyObject {
    func configure(with view: HistoryViewController)
}

final class HistoryConfigurator: HistoryConfiguratorProtocol {
    func configure(with viewController: HistoryViewController) {
        
        let presenter = HistoryPresenter(view: viewController)
        let interactor = HistoryInteractor(presenter: presenter)
        let router = HistoryRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
