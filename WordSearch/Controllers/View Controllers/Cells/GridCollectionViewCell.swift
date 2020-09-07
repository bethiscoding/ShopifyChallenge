//
//  GridCollectionViewCell.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/7/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
 
    static let cellId = "GridCell"

    private let animationScaleFactor: CGFloat = 1.5

    @IBOutlet weak var label: UILabel!

    override var isSelected: Bool {
        didSet {
            /// Scale up the letter if it's selected.
            let transform = isSelected ? CGAffineTransform(scaleX: animationScaleFactor, y: animationScaleFactor) : .identity
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: [], animations: {
                self.label.transform = transform
            }) { (_) in }
        }
    }
    
} //End
