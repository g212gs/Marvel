//
//  CharacterListScreen.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 17/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit
import SwiftyJSON

class CharacterListScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblAttribution: UILabel!
    
    var arrCharecters: [Characters] = [Characters]()
    
    let loaderView: LoaderView = LoaderView.fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.tableView.tableFooterView = UIView()
        
        self.view.backgroundColor = UIColor.black
        self.tableView.backgroundColor = UIColor.clear
        
        self.lblAttribution.text = nil
        self.setupLoaderView()
        
        self.callWebAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "CHARACTERS"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    func setupLoaderView() {
//        self.setupNormalEmptyView()
        tableView.backgroundView = loaderView
        loaderView.isHidden = true
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        // Handle tap to retry
        self.loaderView.lblInstruction.addTapGestureRecognizer {
            self.callWebAPI()
        }
    }
}

extension CharacterListScreen: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCharecters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell: CharacterListCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterListCell.self)
            , for: indexPath) as? CharacterListCell {
            cell.charactersObj = self.arrCharecters[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

extension CharacterListScreen: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character: Characters = self.arrCharecters[indexPath.row]
        
        if let characterDetailScreen: CharacterDetailScreen = self.storyboard?.instantiateViewController(withIdentifier: String(describing: CharacterDetailScreen.self)) as? CharacterDetailScreen {
            
            characterDetailScreen.strAttribution = self.lblAttribution.text ?? ""
            characterDetailScreen.character = character
            self.navigationController?.pushViewController(characterDetailScreen, animated: true)
            
        }
    }
}

extension CharacterListScreen {
    
    func startProgessHUD() {
        self.loaderView.isHidden = false
        self.loaderView.startAnimating()
    }
    
    func stopProgessHUD() {
        self.loaderView.isHidden = true
        self.loaderView.stopAnimating()
    }
    
    func callWebAPI() {
        
        let value = String(Date().millisecondsSince1970)
        let stringValue = String(value)
        let ts: String = stringValue
        
        guard let hash = (ts + Constants.kAPI_KEY_Private + Constants.kAPI_KEY_Public).hashed(HashType.md5, output: HashOutputType.hex) else {
            print("Failed to generate hash value")
            return
        }
        
        let dictParameter: [String: Any] = [
            "ts": ts,
            "apikey": Constants.kAPI_KEY_Public,
            "hash": hash,
            "limit": Constants.kCharacterLimit
        ]
        
        print("dictParameter: \(dictParameter)")
        
        DispatchQueue.main.async {
            self.startProgessHUD()
        }
        
        let webAPIsessionObj: WebAPISession = WebAPISession()
        webAPIsessionObj.callWebAPI(wsType: .GET, bodyType: .row_Application_Json, filePathKey: nil, webURLString: kWserviceUrl_Characters
        , parameter: dictParameter) { (response, error) in
            
            DispatchQueue.main.async {
                self.stopProgessHUD()
            }
            
            if let strError = error {
                print("Error: \(strError)")
                DispatchQueue.main.async {
                    
                    self.loaderView.isHidden = false
                    self.loaderView.showFailure(withError: "Tap to Retry")
                    
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
                    
                    self.loaderView.isHidden = false
                    self.loaderView.showFailure(withError: "Tap to Retry")
                    
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
//                print("Character Array: \(self.arrCharecters)")
                
                DispatchQueue.main.async {
                    // Main thread implementation
                    self.lblAttribution.text = strAttributionText?.string ?? ""
                    self.tableView.reloadData()
                }
            }
        }
    }
}
