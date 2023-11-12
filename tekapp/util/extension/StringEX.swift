//
//  String.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import Foundation

///Genel String için custom uzantılar yazıldı.
extension String {
    
    //MARK: Language
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
