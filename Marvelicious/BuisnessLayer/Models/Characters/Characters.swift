//
//  Characters.swift
//
//  Created by Gaurang Lathiya on 15/05/19
//  Copyright (c) g212gs. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Characters: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let comics = "comics"
    static let series = "series"
    static let modified = "modified"
    static let id = "id"
    static let name = "name"
    static let thumbnail = "thumbnail"
    static let urls = "urls"
    static let descriptionValue = "description"
    static let stories = "stories"
    static let resourceURI = "resourceURI"
    static let events = "events"
  }

  // MARK: Properties
  public var comics: Comics?
  public var series: Series?
  public var modified: String?
  public var id: Int?
  public var name: String?
  public var thumbnail: Thumbnail?
  public var urls: [Urls]?
  public var descriptionValue: String?
  public var stories: Stories?
  public var resourceURI: String?
  public var events: Events?

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
    comics = Comics(json: json[SerializationKeys.comics])
    series = Series(json: json[SerializationKeys.series])
    modified = json[SerializationKeys.modified].string
    id = json[SerializationKeys.id].int
    name = json[SerializationKeys.name].string
    thumbnail = Thumbnail(json: json[SerializationKeys.thumbnail])
    if let items = json[SerializationKeys.urls].array { urls = items.map { Urls(json: $0) } }
    descriptionValue = json[SerializationKeys.descriptionValue].string
    stories = Stories(json: json[SerializationKeys.stories])
    resourceURI = json[SerializationKeys.resourceURI].string
    events = Events(json: json[SerializationKeys.events])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = comics { dictionary[SerializationKeys.comics] = value.dictionaryRepresentation() }
    if let value = series { dictionary[SerializationKeys.series] = value.dictionaryRepresentation() }
    if let value = modified { dictionary[SerializationKeys.modified] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = thumbnail { dictionary[SerializationKeys.thumbnail] = value.dictionaryRepresentation() }
    if let value = urls { dictionary[SerializationKeys.urls] = value.map { $0.dictionaryRepresentation() } }
    if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
    if let value = stories { dictionary[SerializationKeys.stories] = value.dictionaryRepresentation() }
    if let value = resourceURI { dictionary[SerializationKeys.resourceURI] = value }
    if let value = events { dictionary[SerializationKeys.events] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.comics = aDecoder.decodeObject(forKey: SerializationKeys.comics) as? Comics
    self.series = aDecoder.decodeObject(forKey: SerializationKeys.series) as? Series
    self.modified = aDecoder.decodeObject(forKey: SerializationKeys.modified) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.thumbnail = aDecoder.decodeObject(forKey: SerializationKeys.thumbnail) as? Thumbnail
    self.urls = aDecoder.decodeObject(forKey: SerializationKeys.urls) as? [Urls]
    self.descriptionValue = aDecoder.decodeObject(forKey: SerializationKeys.descriptionValue) as? String
    self.stories = aDecoder.decodeObject(forKey: SerializationKeys.stories) as? Stories
    self.resourceURI = aDecoder.decodeObject(forKey: SerializationKeys.resourceURI) as? String
    self.events = aDecoder.decodeObject(forKey: SerializationKeys.events) as? Events
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(comics, forKey: SerializationKeys.comics)
    aCoder.encode(series, forKey: SerializationKeys.series)
    aCoder.encode(modified, forKey: SerializationKeys.modified)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(thumbnail, forKey: SerializationKeys.thumbnail)
    aCoder.encode(urls, forKey: SerializationKeys.urls)
    aCoder.encode(descriptionValue, forKey: SerializationKeys.descriptionValue)
    aCoder.encode(stories, forKey: SerializationKeys.stories)
    aCoder.encode(resourceURI, forKey: SerializationKeys.resourceURI)
    aCoder.encode(events, forKey: SerializationKeys.events)
  }

}
