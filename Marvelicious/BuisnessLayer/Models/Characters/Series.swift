//
//  Series.swift
//
//  Created by Gaurang Lathiya on 15/05/19
//  Copyright (c) g212gs. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Series: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let items = "items"
    static let available = "available"
    static let returned = "returned"
    static let collectionURI = "collectionURI"
  }

  // MARK: Properties
  public var items: [Items]?
  public var available: Int?
  public var returned: Int?
  public var collectionURI: String?

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
//    if let items = json[SerializationKeys.items].array { items = items.map { Items(json: $0) } }
    if let itemsList = json[SerializationKeys.items].array { items = itemsList.map { Items(json: $0) } }
    available = json[SerializationKeys.available].int
    returned = json[SerializationKeys.returned].int
    collectionURI = json[SerializationKeys.collectionURI].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = items { dictionary[SerializationKeys.items] = value.map { $0.dictionaryRepresentation() } }
    if let value = available { dictionary[SerializationKeys.available] = value }
    if let value = returned { dictionary[SerializationKeys.returned] = value }
    if let value = collectionURI { dictionary[SerializationKeys.collectionURI] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.items = aDecoder.decodeObject(forKey: SerializationKeys.items) as? [Items]
    self.available = aDecoder.decodeObject(forKey: SerializationKeys.available) as? Int
    self.returned = aDecoder.decodeObject(forKey: SerializationKeys.returned) as? Int
    self.collectionURI = aDecoder.decodeObject(forKey: SerializationKeys.collectionURI) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(items, forKey: SerializationKeys.items)
    aCoder.encode(available, forKey: SerializationKeys.available)
    aCoder.encode(returned, forKey: SerializationKeys.returned)
    aCoder.encode(collectionURI, forKey: SerializationKeys.collectionURI)
  }

}
