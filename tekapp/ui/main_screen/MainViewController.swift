//
//  MainViewController.swift
//  tekapp
//
//  Created by Önder Ada on 24.10.2023.
//

import UIKit

class MainViewController: BaseViewController {
    var searchText = "Star"
    lazy var searchViewModel: SearchViewModel = {
        return SearchViewModel()
    }()
    
    private var searchTextFieldTextSize: CGFloat = 15
    private var searchTextFieldHeight: CGFloat = 50
    let screenSize: CGRect = UIScreen.main.bounds
    let tableViewCellHight: CGFloat = 100.0
    var colletionViewHeight: CGFloat = 0
    var isSearchTableViewLoading = false
    var isTableViewLoading = false
    var isColletionViewLoading = false
    var searchEditEndTimer: Timer? = nil
    var searchTextField:  UITextField!
    var tableViewEmptyLabel:  UILabel!
    var tableView: UITableView!
    var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func initViews() {
        self.searchViewModel.delegate = self
        self.colletionViewHeight = self.view.frame.height / 4
        
        self.initSearchTextField()
        self.initTableView()
        self.initCollectionView()
        self.initTableViewEmptyLabel()
        
        self.addViews()
        self.configureConstraint()
    }
    
    override func initData() {
        self.searchViewModel.getInitSearchData(searchText)
    }
    
    func tableViewLoadNextData() {
        self.searchViewModel.tableViewPage += 1
        self.searchViewModel.getSearchTextData(self.searchText, false)
    }
    
    func colletionViewLoadNextData() {
        self.searchViewModel.collectionPage += 1
        self.searchViewModel.getSearchComedyData()
    }
    
    func startUpdateListAnim(_ view: UIView) {
        view.isHidden = false
        (view as! UIActivityIndicatorView).startAnimating()
    }
    
    func stopUpdateListAnim(_ view: UIView) {
        (view as! UIActivityIndicatorView).stopAnimating()
        view.isHidden = true
    }
    
    func startSearchText(_ text: String) {
        if(self.searchEditEndTimer != nil) {
            self.searchEditEndTimer!.invalidate()
        }
        self.searchEditEndTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in
            self.isSearchTableViewLoading = true
            self.searchViewModel.tableViewList.removeAll()
            self.searchViewModel.tableViewPage = 1
            self.searchText = text
            self.searchViewModel.getSearchTextData(self.searchText, true)
        })
    }
}

//SearchRequestDelegate
extension MainViewController : SearchRequestProtocol {
    func didInitUpdate(with state: ViewState) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                DialogUtil.shared.showLoading()
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    DialogUtil.shared.hideLoading()
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            case .error(let error):
                DialogUtil.shared.hideLoading()
                DialogUtil.shared.showMessage(self, "error".localized(), error)
            }
        }
    }
    
    func didTableViewUpdate(with state: ViewState) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                isTableViewLoading = true
                self.startUpdateListAnim(self.tableView.tableFooterView!)
                self.tableViewEmptyLabel.isHidden = true
            case .success:
                self.isTableViewLoading = false
                self.tableView.reloadData()
                self.stopUpdateListAnim(self.tableView.tableFooterView!)
                if(self.searchViewModel.tableViewList.isEmpty) {
                    self.tableViewEmptyLabel.isHidden = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isSearchTableViewLoading = false
                }
            case .error(_):
                self.isTableViewLoading = false
                self.stopUpdateListAnim(self.tableView.tableFooterView!)
                self.tableViewEmptyLabel.isHidden = false
            }
        }
    }
    
    func didColletionUpdate(with state: ViewState) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                isColletionViewLoading = true
            case .success:
                self.isColletionViewLoading = false
                self.collectionView.reloadData()
            case .error(let error):
                self.isColletionViewLoading = false
                DialogUtil.shared.showMessage(self, "error".localized(), error)
            }
        }
    }
}


//TextField
extension MainViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let addedText = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let searchText = ((textField.text ?? "") + addedText).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (!addedText.isEmpty || searchText.count > 1) {
            startSearchText(searchText)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}



//TableView
extension MainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.tableViewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as! SearchTableViewCell
        
        if searchViewModel.tableViewList.count > indexPath.row {
            let clockRecord = searchViewModel.tableViewList[indexPath.row]
            cell.setCell(clockRecord)
        }
        
        if indexPath.row == searchViewModel.tableViewList.count - 1, searchViewModel.tableViewPage <= searchViewModel.tableViewTotalResults, isTableViewLoading == false, isSearchTableViewLoading == false {
            tableViewLoadNextData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHight
    }
}

extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellVM = self.searchViewModel.tableViewList[indexPath.row]
        self.navigationController?.pushViewController(MainDetailViewController.newIntance(cellVM), animated: true)
    }
}


//CollectionView
extension MainViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.searchViewModel.collectionViewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchCollectionViewCell
        cell.backgroundColor = UIColor.black
        
        if searchViewModel.collectionViewList.count > indexPath.row {
            let clockRecord = searchViewModel.collectionViewList[indexPath.row]
            cell.setCell(clockRecord)
        }
        
        if indexPath.row == searchViewModel.collectionViewList.count - 1, searchViewModel.collectionPage <= searchViewModel.collectionTotalResults, isColletionViewLoading == false {
            self.colletionViewLoadNextData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            let viewModel = self.searchViewModel.tableViewList[indexPath.row]
            if let poster = viewModel.search.Poster {
                viewModel.downloadImage(url: poster, completion: nil)
            }
        }
    }
}

extension MainViewController {
    func initSearchTextField() {
        searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.font = UIFont.systemFont(ofSize: searchTextFieldTextSize)
        searchTextField.borderStyle = UITextField.BorderStyle.roundedRect
        searchTextField.backgroundColor = .white
        searchTextField.textColor = .black
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "search".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        searchTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    func initTableView() {
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        self.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIActivityIndicatorView(style: .white)
    }
    
    func initCollectionView() {
        let displayWidth: CGFloat = self.view.frame.width
        let colletionViewWidth = displayWidth / 1.6
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: colletionViewWidth, height: colletionViewHeight)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.black
        collectionView.addViewBorder(borderColor: UIColor.gray.cgColor, borderWith: 1, borderCornerRadius: 0)
    }
    
    func initTableViewEmptyLabel() {
        tableViewEmptyLabel = UILabel()
        tableViewEmptyLabel.font = UIFont.systemFont(ofSize: searchTextFieldTextSize)
        tableViewEmptyLabel.textColor = .white
        tableViewEmptyLabel.textAlignment = .center
        tableViewEmptyLabel.text = "no_search_data".localized()
        tableViewEmptyLabel.isHidden = true
    }
    
    func addViews() {
        self.baseView.addSubview(self.searchTextField)
        self.baseView.addSubview(self.tableView)
        self.baseView.addSubview(self.collectionView)
        self.baseView.addSubview(self.tableViewEmptyLabel)
    }
    
    func configureConstraint() {
        self.searchTextField.anchor(top: baseView.topAnchor, left: baseView.leftAnchor, bottom: nil, right: baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: searchTextFieldHeight, enableInsets: false)
        self.tableView.anchor(top: self.searchTextField.bottomAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
        self.collectionView.anchor(top: self.tableView.bottomAnchor, left: self.baseView.leftAnchor, bottom: self.baseView.bottomAnchor, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: 0, paddingBottom: (Dimens.shared.spaceNormal / 2), paddingRight: 0, width: 0, height: colletionViewHeight, enableInsets: false)
        self.tableViewEmptyLabel.anchor(top: self.searchTextField.bottomAnchor, left: self.baseView.leftAnchor, bottom: nil, right: self.baseView.rightAnchor, paddingTop: Dimens.shared.spaceNormal, paddingLeft: Dimens.shared.spaceNormal, paddingBottom: 0, paddingRight: Dimens.shared.spaceNormal, width: 0, height: 0, enableInsets: false)
    }
}
