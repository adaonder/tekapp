//
//  SearchViewModelData.swift
//  tekapp
//
//  Created by Önder Ada on 11.11.2023.
//

import Foundation

public struct SearchViewModelData {
    var state : ViewState
    var searchListViewType : SearchListViewType
    
    init(state: ViewState, searchListViewType: SearchListViewType = .multi) {
        self.state = state
        self.searchListViewType = searchListViewType
    }
}
