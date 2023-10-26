//
//  Search.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import Foundation

public struct Search : Decodable {
    var Title : String?
    var Year : String?
    var imdbID  : String?
    var `Type`: String?
    var Poster: String?
    
    
    public enum CodingKeys: String, CodingKey{
        case Title
        case Year
        case imdbID
        case `Type`
        case Poster
    }
}
