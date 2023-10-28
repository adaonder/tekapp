//
//  DetailViewController.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import UIKit


class DetailViewController: BaseVC {
    
    var searchCellVM: SearchCellVM!
    var searchDetail: SearchDetail? = nil
    
    lazy var searchDetailVM: SearchDetailVM = {
        return SearchDetailVM()
    }()
    
    
    private let backButton: UIButton = {
        let btn  = UIButton(type: .custom)
        btn.setImage(UIImage(named: Images.shared.leftArrow), for: .normal)
        btn.setImageTintColor(.white)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageEdgeInsets = UIEdgeInsets(top: Dimens.shared.spaceSmall, left: Dimens.shared.spaceSmall, bottom: Dimens.shared.spaceSmall, right: Dimens.shared.spaceSmall)
        return btn
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
        let vc = DetailViewController()
        vc.searchCellVM = searchCellVM
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    
    override func initViews() {
        addViews()
        setConstraints()
        updateUI()
        
        backButton.setOnClickListener(self, #selector(backButtonListener))
    }
    
    
    override func initData() {
        if let id = searchCellVM.search.imdbID {
            searchDetailVM.getData(id) { result in
                DispatchQueue.main.async {
                    self.searchDetail = result
                    self.updateUIDetailText()
                }
            } _: { error in
                DispatchQueue.main.async {
                    DialogUtil.shared.showMessage(self, "error".localized(), error)
                }
                
            }
        }
    }
    
    
    func addViews() {
        self.baseView.addSubview(backButton)
        self.baseView.addSubview(searchPoster)
        self.baseView.addSubview(searchTitle)
        self.baseView.addSubview(searchPlot)
    }
    
    func setConstraints() {
        let displayHeight: CGFloat = self.view.frame.height
        
        backButton.anchor(top: self.baseView.topAnchor, left: self.baseView.leftAnchor, bottom: nil, right: nil, paddingTop: Dimens.shared.spaceSmall, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: 0, width: Dimens.shared.iconSizeBack, height: Dimens.shared.iconSizeBack, enableInsets: false)
        searchPoster.anchor(top: self.backButton.bottomAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: displayHeight / 4, enableInsets: false)
        searchTitle.anchor(top: self.searchPoster.bottomAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
        searchPlot.anchor(top: self.searchTitle.bottomAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
    }
    
    func updateUI() {
        if let poster = searchCellVM.search.Poster {
            
            self.searchCellVM.downloadImage(url: poster) { [weak self] image in
                DispatchQueue.main.async {
                    self?.searchPoster.image = image
                }
            }
        } else {
            searchPoster.image = UIImage(named: Images.shared.avatar)
        }
        
        searchTitle.text = searchCellVM.search.Title ?? "-"
    }
    
    func updateUIDetailText() {
        self.searchPlot.text = searchDetail?.Plot ?? "-"
    }
    
    @objc func backButtonListener() {
        self.dismiss(animated: true)
    }
}
