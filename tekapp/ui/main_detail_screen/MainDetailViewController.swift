//
//  MainDetailViewController.swift
//  tekapp
//
//  Created by Önder Ada on 27.10.2023.
//

import UIKit


class MainDetailViewController: BaseViewController {
    private var searchCellViewModel: SearchCellViewModel!
    
    lazy var searchDetailViewModel: SearchDetailViewModel = {
        return SearchDetailViewModel()
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
    
    func addViews() {
        self.baseView.addSubview(searchPoster)
        self.baseView.addSubview(searchTitle)
        self.baseView.addSubview(searchPlot)
    }
    
    func setConstraints() {
        let displayHeight: CGFloat = self.view.frame.height
        searchPoster.anchor(top: self.baseView.topAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: displayHeight / 4, enableInsets: false)
        searchTitle.anchor(top: self.searchPoster.bottomAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
        searchPlot.anchor(top: self.searchTitle.bottomAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
    }
    
    func updateUI() {
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
    
    func updateUIDetailText() {
        self.searchPlot.text = self.searchDetailViewModel.searchDetail?.Plot ?? "-"
    }
    
    @objc func backButtonListener() {
        self.dismiss(animated: true)
    }
}

//SearchDetailRequestProtocol
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
