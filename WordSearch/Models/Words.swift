//
//  Words.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/5/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import Foundation

enum PlacementType: CaseIterable {
    
    case leftRight
    case rightLeft
    case upDown
    case downUp
    case topLeftBottomRight
    case topRightBottomLeft
    case bottomLeftTopRight
    case bottomRightTopLeft
    
    var movement: (x: Int, y: Int) {
        switch self {
        case .leftRight:
            return (1,0)
        case .rightLeft:
            return (-1, 0)
        case .upDown:
            return (0, 1)
        case .downUp:
            return (0, -1)
        case .topLeftBottomRight:
            return (1, 1)
        case .topRightBottomLeft:
            return (-1, 1)
        case .bottomLeftTopRight:
            return (1, -1)
        case .bottomRightTopLeft:
            return (-1, -1)
        }
    }
}

enum Difficulty {
    case easy
    case medium
    case hard
    
    var placementTypes: [PlacementType] {
        switch self {
        case .easy:
            return [.leftRight, .upDown].shuffled()
        case .medium:
            return [.leftRight, .rightLeft, .upDown, .downUp].shuffled()
        case .hard:
            return PlacementType.allCases.shuffled()
        }
    }
}

//struct Word: Decodable {
//    var text: String
//}

class Label {
    var letter: Character = " "
}

class WordSearch {
    
    let allLetters = (65...90).map { Character(Unicode.Scalar($0)) }
    //var words = [Word]()
    var words = ["Swift", "Kotlin", "ObjectiveC", "Variable", "Java", "Mobile"]
    var gridSize = 10
    var labels = [[Label]]()
    var difficulty = Difficulty.hard
    //var numOfPages = 10
    
    var letters = [Character]()
    
    // MARK: - Methods
    
    func makeGrid() {
        labels = (0 ..< gridSize).map { _ in
            (0 ..< gridSize).map { _ in Label() }
        }
            
        placeWords()
        fillGaps()
        printGrid()
    }
    
    private func fillGaps() {
        for column in labels {
            for label in column {
                if label.letter == " " {
                    label.letter = allLetters.randomElement()!
                }
            }
        }
    }
    
    private func printGrid() {
        for column in labels {
            for row in column {
                print(row.letter, terminator: "")
                letters.append(row.letter)
            }
            
            print("")
        }
    }
    
    private func labels(fromX x: Int, y: Int, word: String, movement: (x: Int, y: Int)) -> [Label]? {
        var returnValue = [Label]()
        var xPosition = x
        var yPosition = y
        
        for letter in word {
            let label = labels[xPosition][yPosition]
            
            if label.letter == " " || label.letter == letter {
                returnValue.append(label)
                xPosition += movement.x
                yPosition += movement.y
            } else {
                return nil
            }
        }
        
        return returnValue
    }
    
    private func tryPlacing(_ word: String, movement: (x: Int, y: Int)) -> Bool {
        let xLength = (movement.x * (word.count - 1))
        let yLength = (movement.y * (word.count - 1))
        
        let rows = (0 ..< gridSize).shuffled()
        let columns = (0 ..< gridSize).shuffled()
        
        for row in rows {
            for column in columns {
                let finalX = column + xLength
                let finalY = row + yLength
                
                if finalX >= 0 && finalX < gridSize && finalY >= 0 && finalY < gridSize {
                    if let returnValue = labels(fromX: column, y: row, word: word, movement: movement) {
                        for (index, letter) in word.enumerated() {
                            returnValue[index].letter = letter
                        }
                        
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    //double check that this works
    private func place(_ word: String) -> Bool {
        let formattedWord = word.replacingOccurrences(of: " ", with: "").uppercased()
        
        for type in difficulty.placementTypes {
            if tryPlacing(formattedWord, movement: type.movement) {
                return true
            }
        }
        
//        return difficulty.placementTypes.contains {
//            tryPlacing(formattedWord, movement: $0.movement)
//        }
        
        return false
    }
    
    private func placeWords() -> [String] {
        words.shuffle()
        
        var usedWords = [String]()
        
        for word in words {
            if place(word) {
                usedWords.append(word)
            }
        }
        
        return usedWords
        
        //return words.shuffled().filter(place)
    }
    
} //End
