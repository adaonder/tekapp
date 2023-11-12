//
//  SearchViewModel.swift
//  tekapp
//
//  Created by Önder Ada on 26.10.2023.
//

import Foundation


final class SearchViewModel {
    
    //MARK: Properties
    weak var delegate: SearchRequestProtocol?
    private var searchViewModelData: SearchViewModelData {
        didSet {
            switch searchViewModelData.searchListViewType {
            case .multi:
                self.delegate?.didInitUpdate(with: searchViewModelData.state)
                break
            case .searchTableView:
                self.delegate?.didTableViewUpdate(with: searchViewModelData.state)
                break
            case .searchColletionView:
                self.delegate?.didColletionUpdate(with: searchViewModelData.state)
                break
            }
        }
    }
    private var defaultSearchText = "Star"
    private let defaultSearchCollectionText = "Comedy"
    private var oldRequestPath : String? = nil
    var tableViewList = [SearchCellViewModel]()
    var collectionViewList = [SearchCellViewModel]()
    var tableViewPage:Int = 1
    var collectionPage:Int = 1
    var tableViewTotalResults:Int = 0
    var collectionTotalResults:Int = 0
    
    
    init() {
        self.searchViewModelData = SearchViewModelData(state: .idle)
    }
    
    
    func getInitSearchData(_ searchText: String) {
        var callbackErrorText: String? = nil
        self.searchViewModelData = SearchViewModelData(state: .loading)
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        self.getSearchTextData(searchText, self.tableViewPage, false) { currentList in
            dispatchGroup.leave()
        } _: { error in
            callbackErrorText = error
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.getSearchComedyData(self.collectionPage) { currentList in
            dispatchGroup.leave()
        } _: { error in
            callbackErrorText = error
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let callbackErrorText = callbackErrorText {
                self.searchViewModelData = SearchViewModelData(state: .error(callbackErrorText))
            } else {
                self.searchViewModelData = SearchViewModelData(state: .success)
            }
        }
    }
    
    func getSearchTextData(_ searchText: String, _ searchEnable: Bool) {
        self.searchViewModelData = SearchViewModelData(state: .loading, searchListViewType: .searchTableView)
        self.getSearchTextData(searchText, self.tableViewPage, searchEnable) { currentList in
            self.searchViewModelData = SearchViewModelData(state: .success, searchListViewType: .searchTableView)
        } _: { error in
            self.searchViewModelData = SearchViewModelData(state: .error(error), searchListViewType: .searchTableView)
        }
    }
    
    func getSearchComedyData() {
        self.searchViewModelData = SearchViewModelData(state: .loading, searchListViewType: .searchColletionView)
        self.getSearchComedyData(self.collectionPage) { currentList in
            self.searchViewModelData = SearchViewModelData(state: .success, searchListViewType: .searchColletionView)
        } _: { error in
            self.searchViewModelData = SearchViewModelData(state: .error(error), searchListViewType: .searchColletionView)
        }
    }
    
    
    private func getSearchTextData(_ searchText: String, _ page: Int, _ searchEnable: Bool = true, _ success: @escaping ([Search]) -> Void, _ callbackError : @escaping (String) -> Void ) {
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
    
    private func successEmpty(_ success: @escaping ([Search]) -> Void) {
        self.tableViewList.removeAll()
        self.tableViewTotalResults = 0
        success([])
    }
    
    private func getSearchComedyData (_ page: Int, _ success: @escaping ([Search]) -> Void, _ callbackError : @escaping (String) -> Void ) {
        
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
