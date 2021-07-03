//
//  TranslateTableConfigurator.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 23.06.2021.
//

import Foundation

protocol TranslateTableConfiguratorProtocol: AnyObject {
    func configure(with viewController: TranslateTableViewController)
}

final class TranslateTableConfigurator: TranslateTableConfiguratorProtocol {
    
    func configure(with viewController: TranslateTableViewController) {
        let presenter = TranslateTablePresenter(view: viewController)
        let interactor = TranslateTableInteractor(presenter: presenter)
        let router = TranslateTableRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }

}
