//  yahtzee - HighScoreViewController.swift
//  Created by Travis Luckenbaugh on 6/23/23.

import UIKit

class HighScoreViewController: UIViewController {
    var topGames: [HighScore] = [] { didSet {
        guard isViewLoaded else { return }
        loadData()
    }}
    
    @IBOutlet weak var highScore1: UILabel!
    @IBOutlet weak var highScore2: UILabel!
    @IBOutlet weak var highScore3: UILabel!
    @IBOutlet weak var highScore4: UILabel!
    @IBOutlet weak var highScore5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    @IBAction func closeDidPress(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func loadData() {
        highScore1.text = topGames.count > 0 ? topGames[0].total.description : ""
        highScore2.text = topGames.count > 1 ? topGames[1].total.description : ""
        highScore3.text = topGames.count > 2 ? topGames[2].total.description : ""
        highScore4.text = topGames.count > 3 ? topGames[3].total.description : ""
        highScore5.text = topGames.count > 4 ? topGames[4].total.description : ""
    }
}
