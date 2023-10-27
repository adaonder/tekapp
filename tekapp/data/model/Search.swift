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
    
    
    //For Detail
    var Actors: String?
    var Plot: String?
    var Response: String?
    var Error: String?
    
    
    public enum CodingKeys: String, CodingKey{
        case Title
        case Year
        case imdbID
        case `Type`
        case Poster
        case Actors
        case Plot
        case Response
        case Error
    }
}
