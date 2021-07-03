//
//  TranslateTablePresenter.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 23.06.2021.
//

import Foundation

protocol TranslateTablePresenterProtocol: AnyObject {
    var textToTranslate: String? { get }
    var translatedText: String? { get }
    
    func viewDidLoad()
    func getTranslate(for input: String, sourceLanguage: String, targetLanguage: String)
    func toggleLanguageButton(_ sourceLanguage: String?, _ targetLanguage: String?)
    func changeLanguage(language: String?, buttonTag: Int)
    func setSourceTargetText(source: String, target: String)
}

final class TranslateTablePresenter {
    unowned var view: TranslateTableViewProtocol
    var interactor: TranslateTableInteractorProtocol!
    var router: TranslateTableRouterProtocol!
    
    internal var textToTranslate: String?
    internal var translatedText: String?
    
    required init(view: TranslateTableViewProtocol) {
        self.view = view
    }
}

//MARK: - TranslateTablePresenterProtocol
extension TranslateTablePresenter: TranslateTablePresenterProtocol {
        
    func viewDidLoad() {
        CoreDataManager.instance.fetchData { [weak self] translate in
            guard let self = self else { return }
            let translate = translate.first
            self.textToTranslate = translate?.source ?? "Type some word here"
            self.translatedText = translate?.target ?? "Then tap here"
            self.view.updateView(with: translate)
        }
    }
    
    func getTranslate(for input: String, sourceLanguage: String, targetLanguage: String) {
        interactor.provideTranslate(for: input,
                                    sourceLanguage: sourceLanguage,
                                    targetLanguage: targetLanguage)
    }
    
    func changeLanguage(language: String?, buttonTag: Int) {
        // TODO router to ChangeLanguageVC
    }
    
    func toggleLanguageButton(_ sourceLanguage: String?,
                              _ targetLanguage: String?) {
        
        guard let sourceLanguage = sourceLanguage,
              let targetLanguage = targetLanguage
        else { return }
        
        view.updateLanguageBar(sourceLanguage: targetLanguage,
                               targetLanguage: sourceLanguage)
    }
    
    func setSourceTargetText(source: String, target: String) {
        textToTranslate = source
        translatedText = target
    }
}

//MARK: - TranslateTableInteractorOutputProtocol
extension TranslateTablePresenter: TranslateTableInteractorOutputProtocol {
    func translateDidReceived(textToTranslate: String, translatedText: String) {
        self.textToTranslate = textToTranslate
        self.translatedText = translatedText
        view.updateTranslate()
    }
}
