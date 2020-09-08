//
//  WordSearch.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/4/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import Foundation

typealias Grid = [[Character]]

fileprivate class CharacterRandomizer {
    
    var allLetters = (65...90).map { Character(Unicode.Scalar($0)) }
    func randomChar() -> Character {
        return allLetters.randomElement()!
    }
}

fileprivate extension Grid {
    func randomizePlaceHolders() -> Grid {
        var grid = self
        guard !self.isEmpty && !self[0].isEmpty else {
            return grid
        }
        let randomizer = CharacterRandomizer()
        for i in 0..<self.count {
            for j in 0..<self[0].count {
                if grid[i][j] == WordGridGenerator.placeholder {
                    grid[i][j] = randomizer.randomChar()
                }
            }
        }
        return grid
    }
}

class WordGridGenerator {

    private struct MovingStep {
        var stepRow: Int
        var stepCol: Int
    }

    private enum Direction: CaseIterable {
        case up
        case down
        case left
        case right
        case upLeft
        case upRight
        case downLeft
        case downRight

        func getMovingSteps() -> MovingStep {
            switch self {
            case .up:
                return MovingStep(stepRow: -1, stepCol: 0)
            case .down:
                return MovingStep(stepRow: 1, stepCol: 0)
            case .left:
                return MovingStep(stepRow: 0, stepCol: -1)
            case .right:
                return MovingStep(stepRow: 0, stepCol: 1)
            case .upLeft:
                return MovingStep(stepRow: -1, stepCol: -1)
            case .upRight:
                return MovingStep(stepRow: -1, stepCol: 1)
            case .downLeft:
                return MovingStep(stepRow: 1, stepCol: -1)
            case .downRight:
                return MovingStep(stepRow: 1, stepCol: 1)
            }
        }
    }

    private class State {
        var grid: Grid

        var words: [String]
        var directions: [Direction]
        var positions: [Int]

        init(grid: Grid, words: [String], directions: [Direction], positions: [Int]) {
            self.grid = grid
            self.words = words
            self.directions = directions
            self.positions = positions
        }
    }

    var words: [String] = []
    var wordsMap: [String: String] = [:]
    var nRow: Int = 10
    var nCol: Int = 10

    private var directions = Direction.allCases

    init(words: [String], row: Int, column: Int) {
        self.words = words
        self.nRow = row
        self.nCol = column
    }

    static let placeholder: Character = "#"

    /// We declare this to be a static func to be used by other classes too
    static func wordKey(for startPos: Position, and endPos: Position) -> String {
        return "\(startPos.row):\(startPos.col):\(endPos.row):\(endPos.col)"
    }

    func add(word: String, startPos: Position, endPos: Position) {
        wordsMap[WordGridGenerator.wordKey(for: startPos, and: endPos)] = word
    }

    private func assignWord(
        grid: Grid,
        word: String,
        direction: Direction,
        position: Int) -> (grid: Grid, lastPosition: Position)?  {
        var dupGrid = grid
        var row = position / nRow
        var col = position % nCol
        var idx = 0
        let chars = Array(word)
        let mStep = direction.getMovingSteps()
        var lastPos = Position(row: row, col: col)
        while true {
            if idx == chars.count {
                /// Here the word has been assigned correctly.
                break
            }
            /// The position is in the grid
            if row < 0 || row >= nRow || col < 0 || col >= nCol {
                return nil
            }
            /// This line passes the check above, so the position is valid.
            lastPos = Position(row: row, col: col)

            /// If the current char is a "#" or it equals to the char in the grid,
            /// Then we are fine to move forward.
            if dupGrid[row][col] == WordGridGenerator.placeholder || dupGrid[row][col] == chars[idx] {
                /// update the grid.
                dupGrid[row][col] = chars[idx]
                ///move along the direction
                row += mStep.stepRow
                col += mStep.stepCol
                idx += 1
            } else {
                return nil
            }
        }
        return (grid: dupGrid, lastPosition: lastPos)
    }

    public func generate() -> Grid? {
        let empty = Grid(repeating: [Character](repeating: WordGridGenerator.placeholder, count: nCol), count: nRow)
        let positions = Array(0..<(nRow * nCol)).shuffled()
        let initialState = State(
            grid: empty,
            words: words,
            directions: directions,
            positions: positions.shuffled()
        )
        var states: [State] = [initialState]

        while true {
            guard let state = states.last else {
                /// If we popped out every state, then there's no solution for such a grid.
                return nil
            }
            /// Pop and try the last direction
            var direction = state.directions.last
            state.directions = state.directions.dropLast()
            if direction == nil {
                /// No direction worked at the position, so we try next position
                state.positions = state.positions.dropLast()
                state.directions = Direction.allCases.shuffled()
                direction = state.directions.last!
            }
            let pos = state.positions.last
            if pos == nil {
                states = states.dropLast()
            } else {
                if state.words.isEmpty {
                    /// If we assigned all words, grid is generated.
                    break
                }
                ///We are sure that we have remaining words.
                let word = state.words.last!
                if let (grid, lastPos) = assignWord(grid: state.grid, word: word, direction: direction!, position: pos!) {
                    states.append(State(grid: grid, words: state.words.dropLast(), directions: Direction.allCases.shuffled(), positions: positions))
                    /// Compute the words map
                    let posRow = pos! / nRow
                    let posCol = pos! % nCol
                    add(word: word, startPos: Position(row: posRow, col: posCol), endPos: lastPos)
                }
            }
        }
        return states.last!.grid.randomizePlaceHolders()
    }
    
} //End
