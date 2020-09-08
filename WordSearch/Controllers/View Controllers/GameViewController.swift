//
//  GameViewController.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/7/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Outlets & Properties
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var overlayView: LineOverlay!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var wordListCollectionView: WordListCollectionView!

    let gridSize = 10
    var grid: Grid = Grid()
    let words = ["SWIFT", "KOTLIN", "OBJECTIVEC", "VARIABLE", "JAVA", "MOBILE"]
    lazy var gridGenerator: WordGridGenerator = {
        return WordGridGenerator(words: words, row: gridSize, column: gridSize)
    }()
    

    var elapsedSeconds: Double = 0 {
        didSet {
            timerLabel.text = elapsedSeconds.asTime()
        }
    }
    var timer: Timer?
    var isPaused: Bool = false {
        didSet {
            if isPaused {
                timer?.invalidate()
            } else {
                startTimer()
            }
        }
    }

    /// This should be updated properly in case orientation changes.
    var cellSize: CGSize {
        let width = gridCollectionView.bounds.width / CGFloat(gridSize)
        let height = gridCollectionView.bounds.height / CGFloat(gridSize)
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadGame()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Actions

    @IBAction func quit(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func pauseToggle(_ sender: UIButton) {
        if isPaused {
            isPaused = false
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            isPaused = true
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        gridCollectionView.isHidden = isPaused
    }
    
    // MARK: - Methods

    func setUpViews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.systemPink.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(panHandling(gestureRecognizer:)))
        gridCollectionView.addGestureRecognizer(panGR)
        
        wordListCollectionView.words = gridGenerator.words
        
        overlayView.row = gridSize
        overlayView.col = gridSize
    }
    
    func loadGame() {
        DispatchQueue.global().async {
            if let grid = self.gridGenerator.generate() {
                self.grid = grid
                DispatchQueue.main.async {
                    self.gridCollectionView.reloadData()
                    self.startTimer()
                }
            }
        }
    }

    /// Helper function to get row and col from an indexPath.
    func position(from index: Int) -> Position {
        return Position(row: index / gridSize, col: index % gridSize)
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            self.elapsedSeconds += 1
        })
    }

    @objc func panHandling(gestureRecognizer: UIPanGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: gridCollectionView)
        guard let indexPath = gridCollectionView.indexPathForItem(at: point) else {
            return
        }
        let pos = position(from: indexPath.row)

        switch gestureRecognizer.state {
        case .began:
            overlayView.addTempLine(at: pos)
            /// Select item to animate the cell
            /// Since collection view `selection mode` set to single, this means only one letter is animated at a time.
            /// So in `.ended` event, just need to deselect one cell.
            gridCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        case .changed:
            if overlayView.moveTempLine(to: pos) {
                gridCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        case .ended:
            /// Stop animation
            gridCollectionView.deselectItem(at: indexPath, animated: true)
            guard let startPos = overlayView.tempLine?.startPos else {
                return
            }
            /// Get the word from the pre-computed map
            let key = WordGridGenerator.wordKey(for: startPos, and: pos)
            if let word = gridGenerator.wordsMap[key] {
                overlayView.acceptLastLine()
                wordListCollectionView.select(word: word)
                if overlayView.permanentLines.count == gridGenerator.words.count {
                    
                    ///User has won the game.
                    timer?.invalidate()
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let gameWonViewController = storyBoard.instantiateViewController(withIdentifier: "GameWonVC") as! GameWonViewController
                            self.present(gameWonViewController, animated: true, completion: nil)
                }
            }
            overlayView.removeTempLine()
        default: break
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { (_) in
            /// Force re-draw the collection views when orientation changes.
            self.gridCollectionView.collectionViewLayout.invalidateLayout()
            self.wordListCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
} //End

// MARK: - Collection View

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grid.count * (grid.first?.count ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.cellId, for: indexPath) as! GridCollectionViewCell
        
        let pos = position(from: indexPath.row)
        cell.label.text = String(grid[pos.row][pos.col])
        
        return cell
    }
    
} //End

