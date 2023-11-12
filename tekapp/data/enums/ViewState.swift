//
//  ViewState.swift
//  tekapp
//
//  Created by Önder Ada on 11.11.2023.
//

import Foundation

///View Model ile View arasında durum yönetimi kolaylaştırmak için yazıldı.
enum ViewState {
    case idle
    case loading
    case success
    case error(String)
}
