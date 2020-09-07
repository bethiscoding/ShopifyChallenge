//
//  WordCollectionViewCell.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/7/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var label: UILabel!
    
    static let cellId = "WordCell"

    func configure(with text: String, selected: Bool) {
        if selected {
            /// Strike through the word if it's selected.
            let attrString = NSMutableAttributedString(string: text)
            let attrsDict = [
                NSAttributedString.Key.strikethroughStyle: 2,
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                ] as [NSAttributedString.Key : Any]
            attrString.addAttributes(attrsDict, range: NSRange(location: 0, length: text.count))
            label.attributedText = attrString
        } else {
            label.text = text
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
} //End
