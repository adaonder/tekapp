//
//  SearchCVC.swift
//  tekapp
//
//  Created by Önder Ada on 26.10.2023.
//

import UIKit


class SearchCVC: UICollectionViewCell {
    
    public static var id = "SearchCVC"
    
    private let searchPoster : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        addSubview(searchPoster)
        searchPoster.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: Dimens.shared.spaceSmall, paddingLeft: 0, paddingBottom: Dimens.shared.spaceSmall, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchPoster.image = nil
    }
    
    func setCell(_ viewModel : SearchCellVM) {
        
        if let poster = viewModel.search.Poster {
            viewModel.downloadImage(url: poster) { [weak self] image in
                DispatchQueue.main.async {
                    self?.searchPoster.image = image
                }
            }
        } else {
            searchPoster.image = UIImage(named: Images.shared.avatar)
        }
        
    }
}
