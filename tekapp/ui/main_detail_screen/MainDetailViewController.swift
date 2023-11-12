//
//  MainDetailViewController.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import UIKit


final class MainDetailViewController: BaseViewController {
    //MARK: Properties
    private var searchCellViewModel: SearchCellViewModel!
    
    lazy var searchDetailViewModel: SearchDetailViewModel = {
        return SearchDetailViewModel()
    }()
    
    lazy private var searchPoster : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy private var searchTitle : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: Dimens.shared.textSizeTitle)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy private var searchPlot : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: Dimens.shared.textSizeNormal)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    //MARK: Functions
    static func newIntance (_ searchCellViewModel: SearchCellViewModel) -> MainDetailViewController {
        let vc = MainDetailViewController()
        vc.searchCellViewModel = searchCellViewModel
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    override func initViews() {
        searchDetailViewModel.delegate = self
        addViews()
        setConstraints()
        updateUI()
    }
    
    override func initData() {
        if let id = searchCellViewModel.search.imdbID {
            searchDetailViewModel.getData(id)
        }
    }
    
    private func addViews() {
        self.baseView.addSubview(searchPoster)
        self.baseView.addSubview(searchTitle)
        self.baseView.addSubview(searchPlot)
    }
    
    private func setConstraints() {
        constraintSearchPoster()
        constraintSearchTitle()
        constraintSearchPlot()
    }
    
    private func constraintSearchPoster() {
        let displayHeight: CGFloat = self.view.frame.height
        //searchPoster.anchor(top: self.baseView.topAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: displayHeight / 4, enableInsets: false)
        self.searchPoster.translatesAutoresizingMaskIntoConstraints = false
        self.searchPoster.topAnchor.constraint(equalTo: self.baseView.topAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchPoster.leftAnchor.constraint(equalTo:  self.baseView.leftAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchPoster.rightAnchor.constraint(equalTo:  self.baseView.rightAnchor, constant: -Dimens.shared.spaceNormal).isActive = true
        self.searchPoster.heightAnchor.constraint(equalToConstant: displayHeight / 4).isActive = true
    }
    private func constraintSearchTitle() {
        //searchTitle.anchor(top: self.searchPoster.bottomAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
        self.searchTitle.translatesAutoresizingMaskIntoConstraints = false
        self.searchTitle.topAnchor.constraint(equalTo: self.searchPoster.bottomAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchTitle.leftAnchor.constraint(equalTo:  self.baseView.leftAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchTitle.rightAnchor.constraint(equalTo:  self.baseView.rightAnchor, constant: -Dimens.shared.spaceNormal).isActive = true
    }
    private func constraintSearchPlot() {
        //searchPlot.anchor(top: self.searchTitle.bottomAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
        self.searchPlot.translatesAutoresizingMaskIntoConstraints = false
        self.searchPlot.topAnchor.constraint(equalTo: self.searchTitle.bottomAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchPlot.leftAnchor.constraint(equalTo:  self.baseView.leftAnchor, constant: Dimens.shared.spaceNormal).isActive = true
        self.searchPlot.rightAnchor.constraint(equalTo:  self.baseView.rightAnchor, constant: -Dimens.shared.spaceNormal).isActive = true
    }
    
    private func updateUI() {
        if let poster = searchCellViewModel.search.Poster {
            self.searchCellViewModel.downloadImage(url: poster) { [weak self] image in
                DispatchQueue.main.async {
                    self?.searchPoster.image = image
                }
            }
        } else {
            searchPoster.image = UIImage(named: Images.shared.avatar)
        }
        searchTitle.text = searchCellViewModel.search.Title ?? "-"
    }
    
    private func updateUIDetailText() {
        self.searchPlot.text = self.searchDetailViewModel.searchDetail?.Plot ?? "-"
    }
    
    @objc func backButtonListener() {
        self.dismiss(animated: true)
    }
}

//MARK: SearchDetailRequestProtocol
extension MainDetailViewController : SearchDetailRequestProtocol {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                break
            case .success:
                self.updateUIDetailText()
            case .error(let error):
                DialogUtil.shared.showMessage(self, "error".localized(), error)
            }
        }
    }
}
