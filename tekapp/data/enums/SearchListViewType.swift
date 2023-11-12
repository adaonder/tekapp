//
//  SearchListViewType.swift
//  tekapp
//
//  Created by Önder Ada on 11.11.2023.
//

import Foundation

///MainViewController için birden fazla list view olduğu için init ve her bir list view için ayrı durumu kotnrol etmek için yazıldı.
enum SearchListViewType {
    case multi
    case searchTableView
    case searchColletionView
}
