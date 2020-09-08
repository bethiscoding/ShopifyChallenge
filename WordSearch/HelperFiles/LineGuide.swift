//
//  LineGuide.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/7/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

struct LineStyle {
    var opacity: Float
    var lineWidth: CGFloat
    var strokeColor: CGColor
}

struct Position {
    var row: Int
    var col: Int
}

class Line: CAShapeLayer {

    var cellSize: CGSize = .zero

    var lineStyle: LineStyle = LineStyle(
        opacity: 0.5,
        lineWidth: 10,
        strokeColor: UIColor.orange.cgColor
    )

    var startPos: Position?
    var endPos: Position?

    init(style: LineStyle) {
        super.init()
        self.lineStyle = style
    }

    /// To support layer copy when drawing a permanent line of a corrected word from a temporary line.
    override init(layer: Any) {
        super.init(layer: layer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func point(at pos: Position) -> CGPoint {
        return CGPoint(
            x: CGFloat(pos.col) * cellSize.width + cellSize.width / 2,
            y: CGFloat(pos.row) * cellSize.height + cellSize.height / 2)
    }


    func isHorizontal(with endPos: Position) -> Bool {
        guard let startPos = startPos else {
            return false
        }
        return startPos.row == endPos.row
    }


    func isVertical(with endPos: Position) -> Bool {
        guard let startPos = startPos else {
            return false
        }
        return startPos.col == endPos.col
    }

    func isDiagonal(with endPos: Position) -> Bool {
        guard let startPos = startPos else {
            return false
        }
        return abs(startPos.row - endPos.row) == abs(startPos.col - endPos.col)
    }


    /// Check if target end position is a valid one that is horizontal,
    /// vertical or diagonal with the start position. If valid, update the current end position
    ///
    /// - Parameter endPos: target end position of the line
    /// - Returns: if the end position is valid or not
    func attempt(endPos: Position) -> Bool {
        if isHorizontal(with: endPos) ||
            isVertical(with: endPos) ||
            isDiagonal(with: endPos) {
            self.endPos = endPos
            return true
        }
        return false
    }


    /// Draw the line to the containing view
    ///
    /// - Parameter view: containing view
    func draw(on view: UIView) {
        guard let startPos = startPos,
            let endPos = endPos else {
                return
        }
        self.removeFromSuperlayer()
        let tempPath = UIBezierPath()
        tempPath.move(to: point(at: startPos))
        tempPath.addLine(to: point(at: endPos))
        /// This is cell each time drawing
        /// In case we use different styles for each line at runtime.
        opacity = lineStyle.opacity
        lineCap = .round
        lineWidth = lineStyle.lineWidth
        strokeColor = lineStyle.strokeColor
        path = tempPath.cgPath
        view.layer.addSublayer(self)
    }
    
} //End
