//
//  Parameters.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import Foundation

///Genel sabit stringlere ulaşmak için yazıldı.
final public class Parameters{
    
    //MARK: API ENDPOINT
    public static var API_URL = "https://www.omdbapi.com/?apikey=d4bbe46"
    public static var API_ENDPOINT_SEARCH = "&s=%@&page=%@"
    public static var API_ENDPOINT_DETAIL = "&i=%@"
    
    //MARK: API RESPONSE
    public static let responseSuccess = "True"
}
