//
//  LineOverlay.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/7/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

class LineOverlay: UIView {
    
    var tempLine: Line?
    var permanentLines: [Line] = []
    var row: Int = 0
    var col: Int = 0

    /// Should be set externally for future positions computation
    var cellSize: CGSize {
        let w = bounds.width / CGFloat(col)
        let h = bounds.height / CGFloat(row)
        return CGSize(width: w, height: h)
    }

    /// We define styles for temp lines and permanent lines
    lazy var selectingStyle: LineStyle = LineStyle(
        opacity: 0.5,
        lineWidth: min(cellSize.width, cellSize.height) * 0.8,
        strokeColor:
        UIColor.orange.cgColor
    )

    lazy var selectedStyle: LineStyle = LineStyle(
        opacity: 0.5,
        lineWidth: min(cellSize.width, cellSize.height) * 0.8,
        strokeColor:
        UIColor.green.cgColor
    )

    func resetOverlay() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        tempLine = nil
        permanentLines.removeAll()
    }

    func addTempLine(at position: Position) {
        tempLine = Line(style: selectingStyle)
        tempLine?.cellSize = cellSize
        tempLine?.startPos = position
        tempLine?.endPos = position
    }

    func moveTempLine(to position: Position) -> Bool {
        if tempLine?.attempt(endPos: position) == true {
            tempLine?.draw(on: self)
            return true
        }
        return false
    }

    func removeTempLine() {
        self.tempLine?.removeFromSuperlayer()
        self.tempLine = nil
    }

    func acceptLastLine() {
        if let permLine = tempLine {
            permLine.lineStyle = selectedStyle
            permanentLines.append(permLine)
            setNeedsDisplay()
        }
    }

    /// Draw function of a UIView object.
    /// This is called when a line changes or even orientation changes and the content mode is set to `Redraw`.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        tempLine?.cellSize = cellSize
        tempLine?.draw(on: self)
        for line in permanentLines {
            line.cellSize = cellSize
            line.draw(on: self)
        }
    }
    
} //End
