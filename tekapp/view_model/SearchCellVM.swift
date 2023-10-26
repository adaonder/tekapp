//
//  ImageVM.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import Foundation
import UIKit


class SearchCellVM {
    init(_ search : Search) {
        self.search = search
    }
    
    
    var search : Search!
    private var isDownloading = false
    private var cachedImage: UIImage?
    private var callback: ((UIImage?) -> Void)?
    
    func downloadImage(url: String, completion: ((UIImage?) -> Void)?) {
        if let image = cachedImage {
            completion?(image)
            return
        }
        
        guard !isDownloading else {
            self.callback = completion
            return
        }
        
        isDownloading = true
        
        ApiService.shared.makeRequestImage(url: url) { [weak self] data in
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.cachedImage = image
                self?.callback?(image)
                self?.callback = nil
                completion?(image)
            }
        }
    }
}
