//
//  WebAPISession.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 15/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit
import Reachability
import SwiftyJSON

// WebService Type
enum WSType: String {
    case GET = "GET"
    case POST = "POST"
}

// Implemented this with reference of postman
enum BodyType: String {
    case none = "NONE" // No need to supply body
    case multipart = "multipart/form-data"
    case wwwFormUnreloaded = "application/x-www-form-urlencoded"
    case binary = "BINARY" // handling is different way
    case row_Text_Plain = "text/plain"
    case row_Application_Json = "application/json"
    case row_Application_Javascript = "application/javascript"
    case row_Application_Xml = "application/xml"
    case row_Text_Xml = "text/xml"
    case row_Text_Html = "text/html"
}


// Webserver URL
let serverURL: String = "https://gateway.marvel.com:443"

// Web-service list
let kWserviceUrl_Characters: String = serverURL + "/v1/public/characters"

extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = ("\(value)" ).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

// MARK:- Helper for "application/x-www-form-urlencoded"
extension URLRequest {
    
    private func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    mutating func encodeParameters(parameters: [String : String]) {
        httpMethod = "POST"
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value))"
        }
        
        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}

class WebAPISession: NSObject {

    lazy var configurationCustom: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configurationCustom)
    
    typealias webServiceResponceHandler = ((JSON?, String?) -> Void)
    typealias webServiceRequestHandler = ((NSURLRequest?, String?) -> Void)
    
    // MARK: - Web Service Call Method
    public func callWebAPI(wsType:WSType, bodyType: BodyType, filePathKey: String?, webURLString: String, parameter: Dictionary<String, Any>, completion:
        @escaping webServiceResponceHandler) {
        
        // Set up the URL request
        guard let url = URL(string: webURLString) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy
            , timeoutInterval: 30)
        urlRequest.allowsCellularAccess = true // For allow mobile data
        urlRequest.httpMethod = wsType.rawValue
        urlRequest.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        switch wsType {
        case .GET:
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var webURLString_v1 = webURLString
            
            // Set up the Web URL for URLRequest for GET
            let parameterString = parameter.stringFromHttpParameters()
            if parameterString.count > 0 {
                webURLString_v1 = "\(webURLString_v1)?\(parameterString)"
            }
            
            guard let urlLegal = URL(string: webURLString_v1) else {
                print("Error: cannot create URL")
                return
            }
            urlRequest.url = urlLegal
            print("Request URL: \(String(describing: urlRequest.url))")
            
            self.webAPI(urlRequest: urlRequest) { (responce, error) in
                completion(responce, error)
            }
            
            break
        case .POST:
            switch bodyType {
            case .row_Application_Json:
                // Set up the http body for URLRequest
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                self.preparePostParameters(parameter: parameter, urlRequest: urlRequest, completion: { (urlRequestObj, error) in
                    if error != nil {
                        completion(nil, error)
                    }
                    else {
                        urlRequest = urlRequestObj! as URLRequest
                        
                        self.webAPI(urlRequest: urlRequest) { (responce, error) in
                            completion(responce, error)
                        }
                    }
                })
                break
            case .multipart:
                let boundary = "Boundary-\(UUID().uuidString)"
                urlRequest.setValue("\(bodyType.rawValue); boundary=\(boundary)"
                    , forHTTPHeaderField: "Content-Type")
                
                urlRequest.httpBody = createMultiPartFormDataBody(parameters: parameter, boundary: boundary, filepath: filePathKey)
                
                self.webAPI(urlRequest: urlRequest) { (responce, error) in
                    completion(responce, error)
                }
            case .wwwFormUnreloaded:
                urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                urlRequest.encodeParameters(parameters: parameter as! [String : String])
                
                self.webAPI(urlRequest: urlRequest) { (responce, error) in
                    completion(responce, error)
                }
            default:
                break
            }
        }
    }
    
    
    // MARK: - Web Service Engine
    func webAPI(urlRequest: URLRequest, completion: @escaping webServiceResponceHandler) {
        
        // Check internet
        if ReachabilityManager.shared.reachability.connection != .none {
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            let task = self.session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                // check for any errors
                guard error == nil else {
                    print("\(String(describing: error?.localizedDescription))")
                    print(error as Any)
                    completion(nil, error?.localizedDescription)
                    return
                }
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    completion(nil, Constants.kErrorWSNoData)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                    switch httpResponse.statusCode {
                    case 200,409 : // 409 -> for Marvel API
                        do {
                            let json =  try JSON.init(data: responseData, options: .allowFragments)
                            completion(json,nil)
                        }
                        catch let error {
                            completion(nil, error.localizedDescription)
                        }
                    default:
                        do {
                            let json = try JSON(data: responseData)
                            completion(json,nil)
                        }
                        catch  let error {
                            completion(nil, error.localizedDescription)
                        }
                        break
                    }
                }
            })
            task.resume()
        } else {
            completion(nil, Constants.kNoInterNetConnection)
        }
    }
    
    // MARK: - Helper for "POST"
    func preparePostParameters(parameter: Dictionary<String, Any>, urlRequest: URLRequest, completion:
        @escaping webServiceRequestHandler) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: [])
            print("Request URL: \(String(describing: urlRequest.url))")
            
            var urlRequestObj = urlRequest
            urlRequestObj.httpBody = jsonData
            
            completion(urlRequestObj as NSURLRequest, nil)
        } catch {
            print("JSON serialization failed:  \(error)")
            completion(nil, error.localizedDescription)
        }
    }
    
    // MARK: -  Helper for "multipart/form-data"
    func createMultiPartFormDataBody(parameters: [String: Any],
                                     boundary: String,
                                     filepath: String?) -> Data {
        
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        if let fileContentKey = filepath {
            for (key,value) in parameters {
                
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\(key)")
                
                if fileContentKey == key {
                    do {
                        if let filePathURL = value as? String, let assetURL = URL(string: filePathURL) {
                            let data = try Data(contentsOf: assetURL, options: NSData.ReadingOptions.alwaysMapped)
                            
                            var contentType = "image/jpeg"
                            if let swimeObj: MimeType = Swime.mimeType(data: data) {
                                contentType = swimeObj.mime
                            }
                            let fileName = (value as! NSString).lastPathComponent
                            
                            body.appendString("; filename=\"\(fileName)\"\r\n")
                            body.appendString("Content-Type: \(contentType)\r\n\r\n")
                            body.append(data)
                            body.appendString("\r\n")
                            body.appendString("--".appending(boundary.appending("--")))
                        }
                    } catch let error {
                        // contents could not be loaded
                        print("Error while fetch file: \(error.localizedDescription)")
                    }
                } else {
                    // for other value
                    body.appendString("\r\n\r\n\(value)")
                }
            }
        } else {
            for (key,value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\(key)")
                body.appendString("\r\n\r\n\(value)")
            }
        }
        return body as Data
    }
}
