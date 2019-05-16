//
//  Items.swift
//
//  Created by Gaurang Lathiya on 15/05/19
//  Copyright (c) g212gs. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Items: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let type = "type"
    static let name = "name"
    static let resourceURI = "resourceURI"
  }

  // MARK: Properties
  public var type: String?
  public var name: String?
  public var resourceURI: String?

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
    type = json[SerializationKeys.type].string
    name = json[SerializationKeys.name].string
    resourceURI = json[SerializationKeys.resourceURI].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = resourceURI { dictionary[SerializationKeys.resourceURI] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.resourceURI = aDecoder.decodeObject(forKey: SerializationKeys.resourceURI) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(type, forKey: SerializationKeys.type)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(resourceURI, forKey: SerializationKeys.resourceURI)
  }

}
