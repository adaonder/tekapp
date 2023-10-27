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
    let defaultSearchCollectionText = "Comedy"
    var defaultResponse = "True"
    
    var tableViewPage:Int = 1
    var tableViewTotalResults:Int = 0
    
    var collectionPage:Int = 1
    var collectionTotalResults:Int = 0
    
    
    var oldRequestPath : String? = nil
    
    
    func getData(_ searchText: String, _ page: Int, _ searchEnable: Bool = true, _ success: @escaping ([Search]) -> Void, _ callbackError : @escaping (String) -> Void ) {
      
        if searchEnable {
            if let path = oldRequestPath {
                ApiService.shared.cancelAllSearchRunningTask(path)
            }
            
            oldRequestPath = String.init(format: Parameters.API_URL, searchText, "\(page)")
        }
        
        ApiService.shared.makeRequest(searchText: searchText, page: page) { (result: ApiResponse<[Search]>) in
            self.oldRequestPath = nil
            if let list = result.Search, result.Response == self.defaultResponse {
                self.tableViewList.append(contentsOf: list.map({ search in
                    SearchCellVM(search)
                }))
                self.tableViewTotalResults = Int(result.totalResults!) ?? 0
                success(list)
            } else {
                if(searchEnable) {
                    self.tableViewList.removeAll()
                    self.tableViewTotalResults = 0
                    success([])
                } else {
                    callbackError(result.Error ?? "-")
                }
            }
            
        } callbackError: { error in
            self.oldRequestPath = nil
            if(searchEnable) {
                self.tableViewList.removeAll()
                self.tableViewTotalResults = 0
                success([])
            } else {
                callbackError(error ?? "-")
            }
            
        }
    }
    
    
    func getDataForHorList (_ page: Int, _ success: @escaping ([Search]) -> Void, _ callbackError : @escaping (String) -> Void ) {
        
        ApiService.shared.makeRequest(searchText: defaultSearchCollectionText, page: page) { (result: ApiResponse<[Search]>) in
            
            if let list = result.Search, result.Response == self.defaultResponse {
                self.collectionViewList.append(contentsOf: list.map({ search in
                    SearchCellVM(search)
                }))
                self.collectionTotalResults = Int(result.totalResults!) ?? 0
                success(list)
            } else {
                callbackError(result.Error ?? "-")
            }
            
        } callbackError: { error in
            callbackError(error ?? "-")
        }
    }
    
}
