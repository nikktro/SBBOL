//
//  TranslateTableRouter.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 23.06.2021.
//

import Foundation

protocol TranslateTableRouterProtocol: AnyObject {
    func openChangeLanguageViewController() //TODO
}

final class TranslateTableRouter {
    
    unowned var viewController: TranslateTableViewController
    
    init(viewController: TranslateTableViewController) {
        self.viewController = viewController
    }

}

//MARK: - TranslateTableRouterProtocol
extension TranslateTableRouter: TranslateTableRouterProtocol {
    func openChangeLanguageViewController() {
        // TODO router to ChangeLanguageVC
    }
    
    
}
