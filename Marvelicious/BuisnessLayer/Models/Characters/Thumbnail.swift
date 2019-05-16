//
//  Thumbnail.swift
//
//  Created by Gaurang Lathiya on 15/05/19
//  Copyright (c) g212gs. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Thumbnail: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let xtension = "extension"
    static let path = "path"
  }

  // MARK: Properties
  public var xtension: String?
  public var path: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    xtension = json[SerializationKeys.xtension].string
    path = json[SerializationKeys.path].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = xtension { dictionary[SerializationKeys.xtension] = value }
    if let value = path { dictionary[SerializationKeys.path] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.xtension = aDecoder.decodeObject(forKey: SerializationKeys.xtension) as? String
    self.path = aDecoder.decodeObject(forKey: SerializationKeys.path) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(xtension, forKey: SerializationKeys.xtension)
    aCoder.encode(path, forKey: SerializationKeys.path)
  }

}
