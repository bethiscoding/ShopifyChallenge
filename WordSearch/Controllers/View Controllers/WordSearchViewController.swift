//
//  WordSearchViewController.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/5/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

class WordSearchViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var overlayView: LineOverlay!
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var wordsFoundLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    let wordSearch = WordSearch()
    var gridSize = 10
    var words = [String]()
    var letters = [Character]()
    var selectedLetters = ""
    
    var selectMode = false
    var lastSelectedCell = IndexPath()
    
    var timer = Timer()
    var isTimerRunning = false
    var counter = 0.0
    var startTime = Date()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        wordSearch.makeGrid()
        words = wordSearch.words
        letters = wordSearch.letters
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        setupPanGesture()
        setupOverlayView()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.systemPink.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func runTimer() {
        counter += 0.1
        timerLabel.text = counter.asTime()
    }
    
    @objc func didEnterBackground() {
        startTime = Date()
    }
    
    @objc func didEnterForeground() {
        let endTime = Date()
        counter += endTime.timeIntervalSince(startTime)
    }
    
    // MARK: - Letter Selection
    
    private func setupPanGesture() {
        let panG = UIPanGestureRecognizer(target: self, action: #selector(panHandling(gestureRecognizer:)))
        gridCollectionView.addGestureRecognizer(panG)
    }
    
    private func setupOverlayView() {
        overlayView.row = gridSize
        overlayView.col = gridSize
    }
    
    private func position(from index: Int) -> Position {
        return Position(row: index / gridSize, col: index % gridSize)
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
            /// Since we set the collection view `selection mode` to single, this means only one letter is animated at a time.
            /// So in `.ended` event, we just need to deselect one cell.
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
            let key = WordSearch.wordKey(for: startPos, and: pos)
            if let word = wordSearch.wordsMap[key] {
                overlayView.acceptLastLine()
                //wordListCollectionView.select(word: word)
//                if overlayView.permanentLines.count == gridGenerator.words.count {
//                    // Pause the time because user has won the game.
//                    timer?.invalidate()
//                }
            }
            overlayView.removeTempLine()
        default: break
        }
    }
    
} //End

// MARK: - CollectionView Delegate

extension WordSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCollectionViewCell else { return UICollectionViewCell() }
        
//        cell.letter.text = (String(letters[indexPath.row]))
//        cell.letter.textColor = .white
//        cell.letter.font = .systemFont(ofSize: 20)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = collectionView.frame.height / 11
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
} //End

// MARK: - TableView Delegate

extension WordSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        
        cell.textLabel?.text = words[indexPath.row]
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
} //End
