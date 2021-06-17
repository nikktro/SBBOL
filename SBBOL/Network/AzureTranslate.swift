//
//  AzureTranslate.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 16.05.2021.
//

import Foundation
import UIKit

final class AzureTranslate {
    
    var completionHandler: ((String) -> ())?
        
    func getTranslation(for input: String, sourceLanguage: String, targetLanguage: String) {
        
        let azureKey = "7118478ba5e34a56964d996d3f2a1689"
        let location = "northeurope"
        
        guard let selectedFromLangCode = TranslateLanguages(rawValue: sourceLanguage) else { return }
        guard let selectedToLangCode = TranslateLanguages(rawValue: targetLanguage) else { return }

        struct encodeText: Codable {
            var text = String()
        }
        
        let contentType = "application/json"
        let traceID = "A14C9DB9-0DED-48D7-8BBE-C517A1A8DBB0"
        let host = "dev.microsofttranslator.com"
        let apiURL = "https://dev.microsofttranslator.com/translate?api-version=3.0" + "&from=\(selectedFromLangCode)" +
            "&to=\(selectedToLangCode)"
        var encodeTextSingle = encodeText()
        var toTranslate = [encodeText]()
        
        encodeTextSingle.text = input
        toTranslate.append(encodeTextSingle)
        
        let jsonEncoder = JSONEncoder()
        let jsonToTranslate = try? jsonEncoder.encode(toTranslate)
        guard let url = URL(string: apiURL) else { return } // TODO: add error handler
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(location, forHTTPHeaderField: "Ocp-Apim-Subscription-Region")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
        request.addValue(host, forHTTPHeaderField: "Host")
        request.addValue(String(describing: jsonToTranslate?.count),
                         forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonToTranslate
        
        let config = URLSessionConfiguration.default
        let session =  URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { [weak self] (responseData, response, responseError) in
            if responseError != nil {} // TODO: show error alert
            
            guard let responseData = responseData else { return } // TODO: add error handler
            self?.parseJson(jsonData: responseData)
        }
        task.resume()
    }
    
    
    private func parseJson(jsonData: Data) {
        
        let jsonDecoder = JSONDecoder()
        let langTranslations = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: jsonData)
        
        DispatchQueue.main.async {
            if let translatedText = langTranslations?.first?.translations.last?.text {
                self.completionHandler?(translatedText)
            }
        }
    }
    
}
