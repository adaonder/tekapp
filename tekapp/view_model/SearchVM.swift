//
//  SearchVM.swift
//  tekapp
//
//  Created by Önder Ada on 26.10.2023.
//

import Foundation


class SearchVM {
    var tableViewList = [SearchCellVM]()
    var collectionViewList = [SearchCellVM]()
    
    var defaultSearchText = "Star"
    var defaultSearchTextHorList = "Comedy"
    var defaultResponse = "True"
    
    var tableViewPage:Int = 1
    var tableViewTotalResults:Int = 20
    
    var collectionPage:Int = 1
    var collectionTotalResults:Int = 0
    
    
    func getData(_ searchText: String?, _ page: Int , _ success: @escaping ([Search]) -> Void, _ callbackError : @escaping (String?) -> Void ) {
        
        ApiService.shared.makeRequest(searchText: searchText ?? defaultSearchText, page: page) { (result: ApiResponse<[Search]>) in
            
            if let list = result.Search, result.Response == self.defaultResponse {
                self.tableViewList = list.map({ search in
                    SearchCellVM(search)
                })
                self.tableViewTotalResults = Int(result.totalResults!) ?? 0
                success(list)
            } else {
                callbackError(result.Error)
            }
            
        } callbackError: { error in
            callbackError(error)
        }
    }
    
    
    func getDataForHorList (_ searchText: String?, _ page: Int, _ success: @escaping ([Search]) -> Void, _ callbackError : @escaping (String?) -> Void ) {
        
        ApiService.shared.makeRequest(searchText: searchText ?? defaultSearchTextHorList, page: page) { (result: ApiResponse<[Search]>) in
            
            if let list = result.Search, result.Response == self.defaultResponse {
                self.collectionViewList = list.map({ search in
                    SearchCellVM(search)
                })
                self.collectionTotalResults = Int(result.totalResults!) ?? 0
                success(list)
            } else {
                callbackError(result.Error)
            }
            
        } callbackError: { error in
            callbackError(error)
        }
    }
    
}
