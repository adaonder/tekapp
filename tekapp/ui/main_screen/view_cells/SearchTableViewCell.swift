//
//  SearchTableViewCell.swift
//  tekapp
//
//  Created by Önder Ada on 26.10.2023.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    //MARK: Properties
    static var reuseIdentifier = "SearchTableViewCell"
    
    lazy private var searchPoster : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy private var searchTitle : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: Dimens.shared.textSizeHeader)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy private var searchYear : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: Dimens.shared.textSizeTitle)
        lbl.textAlignment = .left
        return lbl
    }()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        
        addSubview(searchPoster)
        addSubview(searchTitle)
        addSubview(searchYear)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    func setCell(_ search : Search) {
        searchTitle.text = search.Title ?? "-"
        searchYear.text = search.Year ?? "-"
        
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
    
    private func setConstraints() {
        constraintSearchPoster()
        constraintSearchTitle()
        constraintSearchPlot()
    }
    
    private func constraintSearchPoster() {
        //searchPoster.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: Dimens.shared.spaceSmall, paddingLeft:  0, paddingBottom:  Dimens.shared.spaceSmall, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        self.searchPoster.translatesAutoresizingMaskIntoConstraints = false
        self.searchPoster.topAnchor.constraint(equalTo: self.topAnchor, constant: Dimens.shared.spaceSmall).isActive = true
        self.searchPoster.leftAnchor.constraint(equalTo:  self.leftAnchor, constant: 0).isActive = true
        self.searchPoster.bottomAnchor.constraint(equalTo:  self.bottomAnchor, constant: -Dimens.shared.spaceSmall).isActive = true
        self.searchPoster.widthAnchor.constraint(equalToConstant: 90).isActive = true
    }
    private func constraintSearchTitle() {
        //searchTitle.anchor(top: topAnchor, left: searchPoster.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        self.searchTitle.translatesAutoresizingMaskIntoConstraints = false
        self.searchTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchTitle.leftAnchor.constraint(equalTo:  self.searchPoster.rightAnchor, constant: 0).isActive = true
        self.searchTitle.rightAnchor.constraint(equalTo:  self.rightAnchor, constant: 0).isActive = true
    }
    private func constraintSearchPlot() {
        //searchYear.anchor(top: searchTitle.bottomAnchor, left: searchPoster.rightAnchor, bottom: nil, right: nil, paddingTop: Dimens.shared.spaceNormal, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        self.searchYear.translatesAutoresizingMaskIntoConstraints = false
        self.searchYear.topAnchor.constraint(equalTo: self.searchTitle.bottomAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchYear.leftAnchor.constraint(equalTo:  self.searchPoster.rightAnchor, constant: 0).isActive = true
    }
}
