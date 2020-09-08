//
//  MenuViewController.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/5/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setUpViews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.systemPink.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

} //End
