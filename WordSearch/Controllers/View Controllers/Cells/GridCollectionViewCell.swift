//
//  GridCollectionViewCell.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/7/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    static let cellId = "GridCell"
    let animationScaleFactor: CGFloat = 1.5

    override var isSelected: Bool {
        didSet {
            /// Scale up the letter if it's selected.
            let transform = isSelected ? CGAffineTransform(scaleX: animationScaleFactor, y: animationScaleFactor) : .identity
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: [], animations: {
                self.label.transform = transform
            })
        }
    }
    
} //End
