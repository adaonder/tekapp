//
//  SearchDetailViewModel.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import Foundation


final class SearchDetailViewModel {
    weak var delegate: SearchDetailRequestProtocol?
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    var searchDetail: SearchDetail?
    
    init() {
        self.state = .idle
    }
    
    func getData(_ id: String) {
        self.state = .loading
        let path = Parameters.API_URL + String.init(format: Parameters.API_ENDPOINT_DETAIL, id)
        ApiService.shared.makeRequest(path: path) { (searchDetail: SearchDetail) in
            if searchDetail.Response == Parameters.responseSuccess {
                self.searchDetail = searchDetail
                self.state = .success
            } else {
                self.state = .error(searchDetail.Error ?? "-")
            }
        } callbackError: { error in
            self.state = .error(error ?? "-")
        }
    }
}
