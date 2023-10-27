//
//  DetailViewController.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import UIKit


class DetailViewController: UIViewController {
    
    var searchCellVM: SearchCellVM!
    var searchDetail: Search? = nil
    
    lazy var searchDetailVM: SearchDetailVM = {
        return SearchDetailVM()
    }()
    
    private let searchPoster : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let searchTitle : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: Dimens.shared.textSizeTitle)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let searchPlot : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: Dimens.shared.textSizeNormal)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    static func newIntance (_ searchCellVM: SearchCellVM) -> DetailViewController {
        let vc = tekapp.DetailViewController()
        vc.searchCellVM = searchCellVM
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setConstraints()
        updateUI()
        getData()
    }
    
    func addViews() {
        self.view.backgroundColor = .black
        self.view.addSubview(searchPoster)
        self.view.addSubview(searchTitle)
        self.view.addSubview(searchPlot)
    }
    
    func setConstraints() {
        let displayHeight: CGFloat = self.view.frame.height
        
        searchPoster.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: displayHeight / 4, enableInsets: false)
        searchTitle.anchor(top: self.searchPoster.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
        searchPlot.anchor(top: self.searchTitle.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
    }
    
    func updateUI() {
        if let poster = searchCellVM.search.Poster {
            
            self.searchCellVM.downloadImage(url: poster) { [weak self] image in
                DispatchQueue.main.async {
                    self?.searchPoster.image = image
                }
            }
        } else {
            searchPoster.image = UIImage(named: "avatar")
        }
        
        searchTitle.text = searchCellVM.search.Title ?? "-"
    }
    
    func updateUIDetailText() {
        self.searchPlot.text = searchDetail?.Plot ?? "-"
    }
    
    
    func getData() {
        if let id = searchCellVM.search.imdbID {
            searchDetailVM.getData(id) { result in
                print("Test 1")
                DispatchQueue.main.async {
                    self.searchDetail = result
                    self.updateUIDetailText()
                }
            } _: { error in
                print("Test error: \(error)")
            }
        }
    }
    
}
