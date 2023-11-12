//
//  SearchCollectionViewCell.swift
//  tekapp
//
//  Created by Önder Ada on 26.10.2023.
//

import UIKit


final class SearchCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    static var reuseIdentifier = "SearchCollectionViewCell"
    
    lazy private var searchPoster : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(searchPoster)
        //searchPoster.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: Dimens.shared.spaceSmall, paddingLeft: 0, paddingBottom: Dimens.shared.spaceSmall, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        self.searchPoster.translatesAutoresizingMaskIntoConstraints = false
        self.searchPoster.topAnchor.constraint(equalTo: self.topAnchor, constant: Dimens.shared.spaceSmall).isActive = true
        self.searchPoster.leftAnchor.constraint(equalTo:  self.leftAnchor, constant: 0).isActive = true
        self.searchPoster.rightAnchor.constraint(equalTo:  self.rightAnchor, constant: 0).isActive = true
        self.searchPoster.bottomAnchor.constraint(equalTo:  self.bottomAnchor, constant: -Dimens.shared.spaceSmall).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        searchPoster.image = nil
    }
    
    func setCell(_ search : Search) {
        if let poster = search.Poster, let posterUrl = NSURL(string: poster) {
            ImageCacheUtil.shared.load(url: posterUrl) { image in
                DispatchQueue.main.async {
                    self.searchPoster.image = image
                }
            }
        } else {
            searchPoster.image = UIImage(named: Images.shared.avatar)
        }
    }
}
