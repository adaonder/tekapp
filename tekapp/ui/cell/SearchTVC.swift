//
//  SearchTVC.swift
//  tekapp
//
//  Created by Önder Ada on 26.10.2023.
//

import UIKit


class SearchTVC: UITableViewCell {
    
    public static var id = "SearchTVC"
    

    
    private let searchPoster : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let searchTitle : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: Dimens.shared.textSizeHeader)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let searchYear : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: Dimens.shared.textSizeTitle)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        
        addSubview(searchPoster)
        addSubview(searchTitle)
        addSubview(searchYear)
        
        searchPoster.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: Dimens.shared.spaceSmall, paddingLeft:  0, paddingBottom:  Dimens.shared.spaceSmall, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        searchTitle.anchor(top: topAnchor, left: searchPoster.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        searchYear.anchor(top: searchTitle.bottomAnchor, left: searchPoster.rightAnchor, bottom: nil, right: nil, paddingTop: Dimens.shared.spaceNormal, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ viewModel : SearchCellVM) {
        
        searchTitle.text = viewModel.search.Title ?? "-"
        searchYear.text = viewModel.search.Year ?? "-"
        
        if let poster = viewModel.search.Poster {
            
            viewModel.downloadImage(url: poster) { [weak self] image in
                DispatchQueue.main.async {
                    self?.searchPoster.image = image
                }
            }
        } else {
            searchPoster.image = UIImage(named: "avatar")
        }
        
    }
    
}
