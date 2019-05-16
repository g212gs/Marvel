//
//  Enums.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 17/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import Foundation
import UIKit

public enum WebServiceFor {
    case PullToRefresh
    case Paging
    case FirstTime
}

public enum DetailCellFor {
    case title
    case description
    case comicsName
    
    var font: UIFont {
        switch self {
        case .title:
            return Constants.AppRegularFontWithSize(size: 24.0)
        case .description:
            return Constants.AppDescriptionFontWithSize(size: 15.0)
        case .comicsName:
            return Constants.AppComicsFontWithSize(size: 15.0)
        }
    }
    
    var color: UIColor {
        switch self {
        case .title:
            return .white
        case .description:
            return .white
        case .comicsName:
            return .white
        }
    }
}
