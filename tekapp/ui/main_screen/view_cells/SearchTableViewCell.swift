//
//  SearchTableViewCell.swift
//  tekapp
//
//  Created by Önder Ada on 26.10.2023.
//

import UIKit


class SearchTableViewCell: UITableViewCell {
    public static var reuseIdentifier = "SearchTableViewCell"
    
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
        return lbl
    }()
    
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
    
    func setCell(_ viewModel : SearchCellViewModel) {
        
        searchTitle.text = viewModel.search.Title ?? "-"
        searchYear.text = viewModel.search.Year ?? "-"
        
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
    
    func setConstraints() {
        constraintSearchPoster()
        constraintSearchTitle()
        constraintSearchPlot()
    }
    
    func constraintSearchPoster() {
        //searchPoster.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: Dimens.shared.spaceSmall, paddingLeft:  0, paddingBottom:  Dimens.shared.spaceSmall, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        self.searchPoster.translatesAutoresizingMaskIntoConstraints = false
        self.searchPoster.topAnchor.constraint(equalTo: self.topAnchor, constant: Dimens.shared.spaceSmall).isActive = true
        self.searchPoster.leftAnchor.constraint(equalTo:  self.leftAnchor, constant: 0).isActive = true
        self.searchPoster.bottomAnchor.constraint(equalTo:  self.bottomAnchor, constant: -Dimens.shared.spaceSmall).isActive = true
        self.searchPoster.widthAnchor.constraint(equalToConstant: 90).isActive = true
    }
    func constraintSearchTitle() {
        //searchTitle.anchor(top: topAnchor, left: searchPoster.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        self.searchTitle.translatesAutoresizingMaskIntoConstraints = false
        self.searchTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchTitle.leftAnchor.constraint(equalTo:  self.searchPoster.rightAnchor, constant: 0).isActive = true
        self.searchTitle.rightAnchor.constraint(equalTo:  self.rightAnchor, constant: 0).isActive = true
    }
    func constraintSearchPlot() {
        //searchYear.anchor(top: searchTitle.bottomAnchor, left: searchPoster.rightAnchor, bottom: nil, right: nil, paddingTop: Dimens.shared.spaceNormal, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        self.searchYear.translatesAutoresizingMaskIntoConstraints = false
        self.searchYear.topAnchor.constraint(equalTo: self.searchTitle.bottomAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchYear.leftAnchor.constraint(equalTo:  self.searchPoster.rightAnchor, constant: 0).isActive = true
    }
}
