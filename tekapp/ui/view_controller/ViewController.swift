//
//  ViewController.swift
//  tekapp
//
//  Created by Önder Ada on 24.10.2023.
//

import UIKit

class ViewController: BaseVC {
    
    var searchText = "Star"
    lazy var searchVM: SearchVM = {
        return SearchVM()
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
    
    
    
    override func initViews() {
        self.colletionViewHeight = self.view.frame.height / 4
        
        self.initSearchTextField()
        self.initTableView()
        self.initCollectionView()
        self.initTableViewEmptyLabel()
        
        self.addViews()
        self.configureConstraint()
    }
    
    
    override func initData() {
        DialogUtil.shared.showLoading()
        self.searchVM.getData(searchText, self.searchVM.tableViewPage, false) { currentList in
            
            self.searchVM.getDataForHorList(self.searchVM.collectionPage) { currentList in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    DialogUtil.shared.hideLoading()
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            } _: { error in
                DialogUtil.shared.hideLoading()
                DialogUtil.shared.showMessage(self, "error".localized(), error)
            }
        } _: { error in
            DialogUtil.shared.hideLoading()
            DialogUtil.shared.showMessage(self, "error".localized(), error)
        }
    }
    
    func getDataForTableView(_ searchEnable: Bool) {
        isTableViewLoading = true
        self.startUpdateListAnim(self.tableView.tableFooterView!)
        
        self.tableViewEmptyLabel.isHidden = true
        self.searchVM.getData(self.searchText, self.searchVM.tableViewPage, searchEnable) { currentList in
            
            DispatchQueue.main.async {
                self.isTableViewLoading = false
                self.tableView.reloadData()
                self.stopUpdateListAnim(self.tableView.tableFooterView!)
                if(currentList.isEmpty) {
                    self.tableViewEmptyLabel.isHidden = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isSearchTableViewLoading = false
                }
            }
        } _: { error in
            DispatchQueue.main.async {
                self.isTableViewLoading = false
                self.stopUpdateListAnim(self.tableView.tableFooterView!)
                self.tableViewEmptyLabel.isHidden = false
                //DialogUtil.shared.showMessage(self, "error".localized(), error)
            }
        }
    }
    
    func getDataForColletionView() {
        isColletionViewLoading = true
        self.searchVM.getDataForHorList(self.searchVM.collectionPage) { currentList in
            DispatchQueue.main.async {
                self.isColletionViewLoading = false
                self.collectionView.reloadData()
            }
        } _: { error in
            self.isColletionViewLoading = false
            DialogUtil.shared.showMessage(self, "error".localized(), error)
        }
    }
    
    
    func tableViewLoadNextData() {
        self.searchVM.tableViewPage += 1
        self.getDataForTableView(false)
    }
    
    func colletionViewLoadNextData() {
        self.searchVM.collectionPage += 1
        self.getDataForColletionView()
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
            self.searchVM.tableViewList.removeAll()
            self.searchVM.tableViewPage = 1
            self.searchText = text
            self.getDataForTableView(true)
        })
    }
}


//TextField
extension ViewController : UITextFieldDelegate {
    
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
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchVM.tableViewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTVC.id, for: indexPath) as! SearchTVC
        
        if searchVM.tableViewList.count > indexPath.row {
            let clockRecord = searchVM.tableViewList[indexPath.row]
            cell.setCell(clockRecord)
        }
        
        if indexPath.row == searchVM.tableViewList.count - 1, searchVM.tableViewPage <= searchVM.tableViewTotalResults, isTableViewLoading == false, isSearchTableViewLoading == false {
            tableViewLoadNextData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHight
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellVM = self.searchVM.tableViewList[indexPath.row]
        self.present(DetailViewController.newIntance(cellVM), animated: true, completion: nil)
    }
}


//CollectionView
extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.searchVM.collectionViewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCVC.id, for: indexPath) as! SearchCVC
        cell.backgroundColor = UIColor.black
        
        if searchVM.collectionViewList.count > indexPath.row {
            let clockRecord = searchVM.collectionViewList[indexPath.row]
            cell.setCell(clockRecord)
        }
        
        if indexPath.row == searchVM.collectionViewList.count - 1, searchVM.collectionPage <= searchVM.collectionTotalResults, isColletionViewLoading == false {
            self.colletionViewLoadNextData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            //print("indexPath: \(indexPath.row)")
            let viewModel = self.searchVM.tableViewList[indexPath.row]
            if let poster = viewModel.search.Poster {
                viewModel.downloadImage(url: poster, completion: nil)
            }
        }
    }
}


extension ViewController {
    
    func initSearchTextField() {
        let displayWidth: CGFloat = self.view.frame.width
        
        searchTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: displayWidth, height: searchTextFieldHeight))
        searchTextField.font = UIFont.systemFont(ofSize: searchTextFieldTextSize)
        searchTextField.borderStyle = UITextField.BorderStyle.roundedRect
        searchTextField.keyboardType = UIKeyboardType.asciiCapable
        searchTextField.returnKeyType = UIReturnKeyType.done
        searchTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        searchTextField.backgroundColor = .white
        searchTextField.textColor = .black
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "search".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        searchTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        searchTextField.delegate = self
    }
    
    func initTableView() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let tableViewHeight = displayHeight - colletionViewHeight - (2 * Dimens.shared.spaceNormal)
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: tableViewHeight))
        self.tableView.register(SearchTVC.self, forCellReuseIdentifier: SearchTVC.id)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        self.tableView.separatorStyle = .singleLine
        //self.tableView.contentInset.bottom = 10
        self.tableView.backgroundColor = .black
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(50))
        self.tableView.tableFooterView = spinner
    }
    
    func initCollectionView() {
        
        let displayWidth: CGFloat = self.view.frame.width
        let colletionViewWidth = displayWidth / 1.6
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: colletionViewWidth, height: colletionViewHeight)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(SearchCVC.self, forCellWithReuseIdentifier: SearchCVC.id)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.black
        collectionView.isPagingEnabled = false
        collectionView.addViewBorder(borderColor: UIColor.gray.cgColor, borderWith: 1, borderCornerRadius: 0)
    }
    
    func initTableViewEmptyLabel() {
        let displayWidth: CGFloat = self.view.frame.width
        
        tableViewEmptyLabel =  UILabel(frame: CGRect(x: 0, y: 0, width: displayWidth, height: searchTextFieldHeight))
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
