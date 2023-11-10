//
//  SearchViewModel.swift
//  tekapp
//
//  Created by Önder Ada on 26.10.2023.
//

import Foundation


class SearchViewModel {
    var tableViewList = [SearchCellViewModel]()
    var collectionViewList = [SearchCellViewModel]()
    var defaultSearchText = "Star"
    let defaultSearchCollectionText = "Comedy"
    var tableViewPage:Int = 1
    var tableViewTotalResults:Int = 0
    var collectionPage:Int = 1
    var collectionTotalResults:Int = 0
    var oldRequestPath : String? = nil
    
    
    func getDataMultiRequest(_ searchText: String, _ completion: @escaping () -> Void, _ callbackError : @escaping (String) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        self.getData(searchText, self.tableViewPage, false) { currentList in
            dispatchGroup.leave()
        } _: { error in
            callbackError(error)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.getDataForHorList(self.collectionPage) { currentList in
            dispatchGroup.leave()
        } _: { error in
            callbackError(error)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func getData(_ searchText: String, _ page: Int, _ searchEnable: Bool = true, _ success: @escaping ([Search]) -> Void, _ callbackError : @escaping (String) -> Void ) {
        let path = Parameters.API_URL + String.init(format: Parameters.API_ENDPOINT_SEARCH, searchText, "\(page)")
        
        if searchEnable {
            if let path = oldRequestPath {
                ApiService.shared.cancelAllSearchRunningTask(path)
            }
            
            oldRequestPath = path
        }
        
        ApiService.shared.makeRequest(path: path) { (result: ApiResponse<[Search]>) in
            self.oldRequestPath = nil
            if let list = result.Search, result.Response == Parameters.responseSuccess {
                self.tableViewList.append(contentsOf: list.map({ search in
                    SearchCellViewModel(search)
                }))
                self.tableViewTotalResults = Int(result.totalResults!) ?? 0
                success(list)
            } else {
                if(searchEnable) {
                    self.successEmpty(success)
                } else {
                    callbackError(result.Error ?? "-")
                }
            }
            
        } callbackError: { error in
            self.oldRequestPath = nil
            if(searchEnable) {
                self.successEmpty(success)
            } else {
                callbackError(error ?? "-")
            }
            
        }
    }
    
    func successEmpty(_ success: @escaping ([Search]) -> Void) {
        self.tableViewList.removeAll()
        self.tableViewTotalResults = 0
        success([])
    }
    
    func getDataForHorList (_ page: Int, _ success: @escaping ([Search]) -> Void, _ callbackError : @escaping (String) -> Void ) {
        
        let path = Parameters.API_URL + String.init(format: Parameters.API_ENDPOINT_SEARCH, defaultSearchCollectionText, "\(page)")
        
        ApiService.shared.makeRequest(path: path) { (result: ApiResponse<[Search]>) in
            
            if let list = result.Search, result.Response == Parameters.responseSuccess {
                self.collectionViewList.append(contentsOf: list.map({ search in
                    SearchCellViewModel(search)
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
