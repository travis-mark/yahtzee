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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if animated {
            let controls = [highScore1, highScore2, highScore3, highScore4, highScore5].compactMap({ $0 })
            let x = controls.map { $0.frame.origin.x }
            let y = controls.map { $0.frame.origin.y }
            let width = controls.map { $0.frame.size.width }
            let height = controls.map { $0.frame.size.height }
            let bottom = view.frame.size.height + 100
            let t0 = [0.0, 0.3, 0.55, 0.75, 0.90]
            let dt = [0.3, 0.25, 0.2, 0.15, 0.1]
            for (i, control) in controls.enumerated() {
                control.frame = CGRect(x: x[i], y: bottom, width: width[i], height: height[i])
                UIView.animate(withDuration: dt[i], delay: t0[i]) {
                    control.frame = CGRect(x: x[i], y: y[i], width: width[i], height: height[i])
                }
            }
        }
        
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
