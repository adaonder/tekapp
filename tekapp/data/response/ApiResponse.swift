//
//  ApiResponse.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import Foundation

public struct ApiResponse<T:Decodable> : Decodable {
    let Search: T?
    let Response: String?
    let totalResults: String?
    let Error: String?
    
    public enum CodingKeys: String, CodingKey {
        case Search
        case Response
        case totalResults
        case Error
    }
    
}
