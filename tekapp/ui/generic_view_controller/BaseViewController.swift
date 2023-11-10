//
//  BaseVC.swift
//  tekapp
//
//  Created by Önder Ada on 28.10.2023.
//

import UIKit


class BaseViewController: UIViewController {
    let baseView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.hideKeyboardWhenTappedAround()
        self.initBaseView()
        initViews()
        setupViews()
        initData()
    }
    
    func initViews() { }
    
    func setupViews() { }
    
    func initData() { }
    
    func initBaseView() {
        self.view.addSubview(self.baseView)
        
        self.baseView.backgroundColor = .black
        self.baseView.translatesAutoresizingMaskIntoConstraints = false
        let guide = self.view.safeAreaLayoutGuide
        self.baseView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        self.baseView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        self.baseView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.baseView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
}
