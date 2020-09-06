//
//  WordSearchViewController.swift
//  WordSearch
//
//  Created by Bethany Morris on 9/5/20.
//  Copyright © 2020 Bethany M. All rights reserved.
//

import UIKit

class WordSearchViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var wordsFoundLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var words = [String]()
    var letters = [Character]()
    
    var timer = Timer()
    var isTimerRunning = false
    var counter = 0.0
    var startTime = Date()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        let wordSearch = WordSearch()
        wordSearch.makeGrid()
        words = wordSearch.words
        letters = wordSearch.letters
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Methods
    
    func setUpViews() {
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

} //End

// MARK: - CollectionView Delegate

extension WordSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //guard let photos = outings.photos else { return }
        return letters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCollectionViewCell else { return UICollectionViewCell() }
                
        cell.letter.text = String(letters[indexPath.row])
        //cell.photo.layer.cornerRadius = 10
        
        print("Letters: \(letters)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = collectionView.frame.height
        return CGSize(width: side, height: side)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
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
        
        return cell
    }
    
} //End
