//
//  ViewController.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 15/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    var arrCharecters: [Characters] = [Characters]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.callWebAPI()
    }
    
}

extension ViewController {
    
    func callWebAPI() {
        
        let value = String(Date().millisecondsSince1970)
        let stringValue = String(value)
        let ts: String = stringValue //"\(NSDate().timeIntervalSince1970 * 1000)"
        
        guard let hash = (ts + Constants.kAPI_KEY_Private + Constants.kAPI_KEY_Public).hashed(HashType.md5, output: HashOutputType.hex) else {
            print("Failed to generate hash value")
            return
        }
        
        let dictParameter: [String: Any] = [
            "ts": ts,
            "apikey": Constants.kAPI_KEY_Public,
            "hash": hash,
            "limit": 20
        ]
        
        print("dictParameter: \(dictParameter)")
        
        //        DispatchQueue.main.async {
        //            self.startProgessHUD()
        //        }
        
        let webAPIsessionObj: WebAPISession = WebAPISession()
        webAPIsessionObj.callWebAPI(wsType: .GET, bodyType: .row_Application_Json, filePathKey: nil, webURLString: kWserviceUrl_Characters
        , parameter: dictParameter) { (response, error) in
            
            //            DispatchQueue.main.async {
            //                self.stopProgessHUD()
            //            }
            
            if let strError = error {
                print("Error: \(strError)")
                DispatchQueue.main.async {
                    self.topMostViewController().showAlert(withTitle: Constants.kApplicationName, message: strError)
                }
            } else {
                print("Response: \(String(describing: response))")
                
                guard let dictResponse = response?.dictionary else {
                    print("No Data Object found")
                    
                    var message = Constants.kErrorWebService
                    if let responseJson = response, let wsMessage = responseJson[Constants.kMessage].rawString() {
                        message = wsMessage
                    }
                    DispatchQueue.main.async {
                        print("message : \(message)")
                        self.topMostViewController().showAlert(withTitle: Constants.kApplicationName, message: message)
                    }
                    return
                }
                
                let strAttributionText = dictResponse[Constants.kAttributionText]
                print("attributionText: \(String(describing: strAttributionText))")
                
                guard let dataObj = dictResponse[Constants.kData]?.dictionary else {
                    print("No Data Object found")
                    return
                }
                let strCount = dataObj[Constants.kCount]
                print("count: \(String(describing: strCount))")
                let strLimit = dataObj[Constants.kLimit]
                print("limit: \(String(describing: strLimit))")
                let strOffset = dataObj[Constants.kOffset]
                print("offset: \(String(describing: strOffset))")
                
                guard let arrResult = dataObj[Constants.kResults]?.array else {
                    print("No Result Object found")
                    return
                }
                
                for characterObj in arrResult {
                    let objCharacter: Characters = Characters(json: characterObj)
                    self.arrCharecters.append(objCharacter)
                }
                print("Character Array: \(self.arrCharecters)")
            }
        }
    }
}

