//  SLocation.swift
//  onTheMap_Fatima
//
//  Created by Fatimah Abdulraheem on  28/01/2019.
//

import Foundation

//We have used Codable to convert from API to object and vise versa.
struct SLocation: Codable {
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var createdAt: String?
    var firstName: String?
    var lastName: String?
}

extension SLocation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}

//define a group of different types:
enum Parmaterss: String {
    case latitude
    case longitude
    case mapString
    case mediaURL
    case objectId
    case uniqueKey
    case updatedAt
    case createdAt
    case firstName
    case lastName
}

