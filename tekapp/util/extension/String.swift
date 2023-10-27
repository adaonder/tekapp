//
//  String.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import Foundation


extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
