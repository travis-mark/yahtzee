//  yahtzee - TitleScreenViewController.swift
//  Created by Travis Luckenbaugh on 6/22/23.

import UIKit

class TitleScreenViewController: UIViewController {
    var currentGame: Game? { didSet {
        continueButton.isEnabled = currentGame != nil
    }}
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentGame = fetchCurrentGame()
    }
    
    @IBAction func newGameDidPress(_ sender: Any) {
        currentGame = startNewGame()
        performSegue(withIdentifier: "startGame", sender: nil)
    }
    
    @IBAction func continueDidPress(_ sender: Any) {
        performSegue(withIdentifier: "startGame", sender: nil)
    }
    
    @IBAction func highScoresDidPress(_ sender: Any) {
        performSegue(withIdentifier: "highScores", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame", let vc = segue.destination as? GameViewController {
            vc.game = currentGame
        }
        
        if segue.identifier == "highScores", let vc = segue.destination as? HighScoreViewController {
            vc.topGames = fetchHighScores()
        }
    }
}
