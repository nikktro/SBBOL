//
//  AzureTranslate.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 16.05.2021.
//

import Foundation
import UIKit

class AzureTranslate {
    
    var completionHandler: ((String) -> ())?
    
    func getTranslation(for input: String) {
                
        let azureKey = "7118478ba5e34a56964d996d3f2a1689"
        let location = "northeurope"
        let selectedFromLangCode = "en"
        let selectedToLangCode = "ru"
        
        struct encodeText: Codable {
            var text = String()
        }
        
        let contentType = "application/json"
        let traceID = "A14C9DB9-0DED-48D7-8BBE-C517A1A8DBB0"
        let host = "dev.microsofttranslator.com"
        let apiURL = "https://dev.microsofttranslator.com/translate?api-version=3.0&from=" + selectedFromLangCode + "&to=" + selectedToLangCode
        
        var encodeTextSingle = encodeText()
        var toTranslate = [encodeText]()
        
        encodeTextSingle.text = input
        toTranslate.append(encodeTextSingle)
        
        let jsonEncoder = JSONEncoder()
        let jsonToTranslate = try? jsonEncoder.encode(toTranslate)
        let url = URL(string: apiURL)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(location, forHTTPHeaderField: "Ocp-Apim-Subscription-Region")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
        request.addValue(host, forHTTPHeaderField: "Host")
        request.addValue(String(describing: jsonToTranslate?.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonToTranslate
        
        let config = URLSessionConfiguration.default
        let session =  URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if responseError != nil {
                print("this is the error ", responseError!)
                let alert = UIAlertController(title: "Could not connect to service", message: "Please check your network connection and try again", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                alert.present(alert, animated: true)
            }
            self.parseJson(jsonData: responseData!)
        }
        task.resume()
    }
    
    
    func parseJson(jsonData: Data) {
        
        struct ReturnedJson: Codable {
            var translations: [TranslatedStrings]
        }
        struct TranslatedStrings: Codable {
            var text: String
            var to: String
        }
        
        let jsonDecoder = JSONDecoder()
        let langTranslations = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: jsonData)
        let numberOfTranslations = langTranslations!.count - 1
        
        //Put response on main thread to update UI
        DispatchQueue.main.async {
            let translatedText = langTranslations![0].translations[numberOfTranslations].text
            self.completionHandler?(translatedText)
        }
    }
    
}
