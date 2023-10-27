//
//  ViewController.swift
//  tekapp
//
//  Created by Önder Ada on 24.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    //var searchVM = SearchVM()
    var searchText = "Star"
    var searchHorText = "Comedy"
    lazy var searchVM: SearchVM = {
        return SearchVM()
    }()
    
    private let basicView = UIView()
    private var searchTextFieldTextSize: CGFloat = 15
    private var searchTextFieldHeight: CGFloat = 50
    private var spaceSize: CGFloat = 20
    
    let screenSize: CGRect = UIScreen.main.bounds
    let tableViewCellHight: CGFloat = 100.0
    var colletionViewHeight: CGFloat = 0
    
    var isTableViewLoading = false
    var isColletionViewLoading = false
    
    
    
    var tableView: UITableView!
    var searchTextField:  UITextField!
    var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        self.hideKeyboardWhenTappedAround()
        self.initViews()
        self.initData()
    }
    
    
    
    func initData() {
        
        DialogUtil.shared.showLoading()
        self.searchVM.getData(searchText, self.searchVM.tableViewPage) { currentList in
            
            self.searchVM.getDataForHorList(self.searchHorText, self.searchVM.collectionPage) { currentList in
                DispatchQueue.main.async {
                    DialogUtil.shared.hideLoading()
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            } _: { error in
                DialogUtil.shared.hideLoading()
                DialogUtil.shared.showMessage(self, "Hata", error)
            }
        } _: { error in
            DialogUtil.shared.hideLoading()
            DialogUtil.shared.showMessage(self, "Hata", error)
        }
    }
    
    func getDataForTableView() {
        self.startUpdateListAnim(self.tableView.tableFooterView!)
        
        self.searchVM.getData(self.searchText, self.searchVM.tableViewPage) { currentList in
            
            DispatchQueue.main.async {
                self.isTableViewLoading = false
                self.tableView.reloadData()
                self.stopUpdateListAnim(self.tableView.tableFooterView!)
            }
        } _: { error in
            DispatchQueue.main.async {
                self.isTableViewLoading = false
                self.stopUpdateListAnim(self.tableView.tableFooterView!)
                DialogUtil.shared.showMessage(self, "Hata", error)
            }
        }
    }
    
    func getDataForColletionView() {
        self.searchVM.getDataForHorList(self.searchHorText, self.searchVM.collectionPage) { currentList in
            DispatchQueue.main.async {
                self.isColletionViewLoading = false
                self.collectionView.reloadData()
            }
        } _: { error in
            self.isColletionViewLoading = false
            DialogUtil.shared.showMessage(self, "Hata", error)
        }
    }
    
    
    func tableViewLoadNextData() {
        isTableViewLoading = true
        searchVM.tableViewPage += 1
        getDataForTableView()
    }
    
    func colletionViewLoadNextData() {
        isColletionViewLoading = true
        searchVM.collectionPage += 1
        getDataForColletionView()
    }
    
    func startUpdateListAnim(_ view: UIView) {
        view.isHidden = false
        (view as! UIActivityIndicatorView).startAnimating()
        
    }
    
    func stopUpdateListAnim(_ view: UIView) {
        (view as! UIActivityIndicatorView).stopAnimating()
        view.isHidden = true
    }
}

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
        
        if indexPath.row == searchVM.tableViewList.count - 1, searchVM.tableViewPage <= searchVM.tableViewTotalResults, isTableViewLoading == false {
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
        
        let clockRecord = self.searchVM.tableViewList[indexPath.row]
        print("Title: \(clockRecord.search.Title)")
        print("imdbID: \(clockRecord.search.imdbID)")
        
    }
}


//Collection
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
        //print("prefetchRowsAt")
        
        
        let infices = indexPaths.map {"\($0.row)"}.joined(separator: ", ")
        
        print("Prefect: \(infices)")
        
        for indexPath in indexPaths {
            print("indexPath: \(indexPath.row)")
            let viewModel = self.searchVM.tableViewList[indexPath.row]
            if let poster = viewModel.search.Poster {
                viewModel.downloadImage(url: poster, completion: nil)
            }
        }
    }
}


extension ViewController {
    
    
    func initViews() {
        self.view.backgroundColor = .black
        
        colletionViewHeight = self.view.frame.height / 4
        
        self.initSearchTextField()
        self.initTableView()
        self.initCollectionView()
        self.initBasicView()
    }
    
    func initBasicView() {
        self.view.addSubview(self.basicView)
        
        self.basicView.backgroundColor = .black
        self.basicView.translatesAutoresizingMaskIntoConstraints = false
        let guide = self.view.safeAreaLayoutGuide
        self.basicView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        self.basicView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        self.basicView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.basicView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
    
    func initSearchTextField() {
        let displayWidth: CGFloat = self.view.frame.width
        
        searchTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: displayWidth, height: searchTextFieldHeight))
        searchTextField.font = UIFont.systemFont(ofSize: searchTextFieldTextSize)
        searchTextField.borderStyle = UITextField.BorderStyle.roundedRect
        searchTextField.keyboardType = UIKeyboardType.default
        searchTextField.returnKeyType = UIReturnKeyType.done
        searchTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        searchTextField.backgroundColor = .white
        searchTextField.textColor = .black
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        searchTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        // sampleTextField.delegate = self
        
        self.basicView.addSubview(searchTextField)
        
        searchTextField.anchor(top: basicView.topAnchor, left: basicView.leftAnchor, bottom: nil, right: basicView.rightAnchor, paddingTop: spaceSize, paddingLeft: spaceSize, paddingBottom: 0, paddingRight: spaceSize, width: 0, height: searchTextFieldHeight, enableInsets: false)
    }
    
    func initTableView() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let tableViewHeight = displayHeight - colletionViewHeight - (2 * spaceSize)
        
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
        
        self.basicView.addSubview(self.tableView)
        
        self.tableView.anchor(top: self.searchTextField.bottomAnchor, left: self.basicView.leftAnchor, bottom: nil, right: self.basicView.rightAnchor, paddingTop: spaceSize, paddingLeft: spaceSize, paddingBottom: 0, paddingRight: spaceSize, width: 0, height: 0, enableInsets: false)
        
    }
    
    func initCollectionView() {
        
        let displayWidth: CGFloat = self.view.frame.width
        let colletionViewWidth = (displayWidth - 40) / 2
        
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
        
        self.basicView.addSubview(collectionView)
        
        collectionView.anchor(top: self.tableView.bottomAnchor, left: self.basicView.leftAnchor, bottom: self.basicView.bottomAnchor, right: self.basicView.rightAnchor, paddingTop: spaceSize, paddingLeft: spaceSize, paddingBottom: (spaceSize / 2), paddingRight: spaceSize, width: 0, height: colletionViewHeight, enableInsets: false)
    }
}



