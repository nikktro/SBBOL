//
//  TranslateTableInteractor.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 23.06.2021.
//

import Foundation

protocol TranslateTableInteractorProtocol: AnyObject {
    func provideTranslate(for inputText: String,
                          sourceLanguage: String,
                          targetLanguage: String)
}

protocol TranslateTableInteractorOutputProtocol: AnyObject {
    func translateDidReceived(textToTranslate: String, translatedText: String)
}


final class TranslateTableInteractor {
    
    private let azure = AzureTranslate()
    
    unowned var presenter: TranslateTableInteractorOutputProtocol
    
    required init(presenter: TranslateTableInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
}

//MARK: - TranslateTableInteractorProtocol
extension TranslateTableInteractor: TranslateTableInteractorProtocol {
    func provideTranslate(for inputText: String,
                          sourceLanguage: String,
                          targetLanguage: String) {
        
        azure.getTranslation(for: inputText,
                             sourceLanguage: sourceLanguage,
                             targetLanguage: targetLanguage)
        
        azure.completionHandler = { [weak self] translate in
            guard let self = self else { return }
            self.presenter.translateDidReceived(textToTranslate: inputText,
                                       translatedText: translate)
            
            CoreDataManager.instance.saveData(
                with: TranslateModel(source: inputText,
                                     sourceLang: sourceLanguage,
                                     target: translate,
                                     targetLang: targetLanguage,
                                     date: Date()))
        }
    }
}
