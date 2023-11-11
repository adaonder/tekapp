//
//  SearchRequestDelegate.swift
//  tekapp
//
//  Created by Önder Ada on 11.11.2023.
//

import Foundation

protocol SearchRequestProtocol: AnyObject {
    func didInitUpdate(with state: ViewState)
    func didTableViewUpdate(with state: ViewState)
    func didColletionUpdate(with state: ViewState)
}
