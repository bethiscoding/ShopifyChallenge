//
//  GameWonViewController.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/7/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

class GameWonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.systemPink.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        
    }

} //End
