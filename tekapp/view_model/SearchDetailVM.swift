//
//  SearchDetailVM.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import Foundation


class SearchDetailVM {
    
    
    func getData (_ id: String, _ completion: @escaping (Search) -> Void, _ callbackError : @escaping (String) -> Void ) {
        
        let path = Parameters.API_URL + String.init(format: Parameters.API_ENDPOINT_DETAIL, id)
        
        ApiService.shared.makeRequest(path: path) { (result: Search) in
            
            if result.Response == Parameters.responseSuccess {
                completion(result)
            } else {
                callbackError(result.Error ?? "-")
            }
            
        } callbackError: { error in
            callbackError(error ?? "-")
        }
    }
}
