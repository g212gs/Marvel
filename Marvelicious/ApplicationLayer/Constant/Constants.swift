//
//  Constants.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 15/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

class Constants: NSObject {

    //application constant
    static let kApplicationName         =   "Marvelicious"
    
    static let SCREEN_SIZE: CGRect      =   UIScreen.main.bounds
    
    //font constant
    static let kFONT_REGULAR =              "Marvel-Regular"
    static let kFONT_DESCRIPTION =          "DeliusSwashCaps-Regular"
    static let kFONT_COMICS =               "Dr.Charmed"
    
    
    static func AppRegularFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: Constants.kFONT_REGULAR, size: size)!
    }
    
    static func AppDescriptionFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: Constants.kFONT_DESCRIPTION, size: size)!
    }
    
    static func AppComicsFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: Constants.kFONT_COMICS, size: size)!
    }
    
    //AlertTitle Constants
    static let kAlertTypeOK             =   "OK"
    static let kAlertTypeCancel         =   "Cancel"
    static let kAlertTypeYES            =   "YES"
    static let kAlertTypeNO             =   "NO"
    
    // Internet connection
    static let kNoInterNetConnection    =   "No Internet Connection."
    
    // Error
    static let kErrorWebService         =   "Please try again."
    static let kErrorWSNoData           =   "No data found."
    
    // Marvel API data
    static let kAPI_KEY_Public          =   "92c18843e7a27f8f994322c7b9e90789"
    static let kAPI_KEY_Private         =   "f7a1d5b6cac1198ab22670ffb17d47fc8e2faf4a"
    
    // WebService constants
    static let kStatus                  =   "status"
    static let kMessage                 =   "message"
    static let kResponse                =   "response"
    static let kAttributionText         =   "attributionText"
    static let kData                    =   "data"
    static let kResults                 =   "results"
    static let kOffset                  =   "offset"
    static let kLimit                   =   "limit"
    static let kCount                   =   "count"
    
    static let kCharacterLimit                   =   20
}
