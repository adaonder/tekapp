//
//  SearchDetailRequestProtocol.swift
//  tekapp
//
//  Created by Önder Ada on 11.11.2023.
//

import Foundation

protocol SearchDetailRequestProtocol: AnyObject {
    func didUpdate(with state: ViewState)
}
