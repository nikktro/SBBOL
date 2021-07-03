//
//  HistoryRouter.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 26.06.2021.
//

import Foundation

protocol HistoryRouterProtocol {
    func openTranslateTableViewController (with translate: Translate)
}

final class HistoryRouter {
    
    weak var viewController: HistoryViewController!
    
    var completionTranslate: ((Translate) -> Void)?
    
    init(viewController: HistoryViewController) {
        self.viewController = viewController
    }
}

extension HistoryRouter: HistoryRouterProtocol {
    func openTranslateTableViewController(with translate: Translate) {
        
        viewController.tabBarController?.selectedIndex = 0
        let selectedViewController = viewController.tabBarController?.selectedViewController
        let translateTableViewController = selectedViewController as? TranslateTableViewController
        translateTableViewController?.presenter.setSourceTargetText(
            source: translate.source ?? "",
            target: translate.target ?? "")
        
        translateTableViewController?.updateView(with: translate)
    }
}
