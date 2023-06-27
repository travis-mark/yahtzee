//  yahtzee - GameViewController.swift
//  Created by Travis Luckenbaugh on 6/16/23.

import UIKit

class GameViewController: UIViewController {
    var game: Game!
    
    @IBOutlet weak var die1ImageView: UIImageView!
    @IBOutlet weak var die1HoldButton: UIButton!
    @IBOutlet weak var die2ImageView: UIImageView!
    @IBOutlet weak var die2HoldButton: UIButton!
    @IBOutlet weak var die3ImageView: UIImageView!
    @IBOutlet weak var die3HoldButton: UIButton!
    @IBOutlet weak var die4ImageView: UIImageView!
    @IBOutlet weak var die4HoldButton: UIButton!
    @IBOutlet weak var die5ImageView: UIImageView!
    @IBOutlet weak var die5HoldButton: UIButton!
    @IBOutlet weak var rollDiceButton: UIButton!
    @IBOutlet weak var onesButton: UIButton!
    @IBOutlet weak var twosButton: UIButton!
    @IBOutlet weak var threesButton: UIButton!
    @IBOutlet weak var foursButton: UIButton!
    @IBOutlet weak var fivesButton: UIButton!
    @IBOutlet weak var sixesButton: UIButton!
    @IBOutlet weak var bonusButton: UIButton!
    @IBOutlet weak var threeOfAKindButton: UIButton!
    @IBOutlet weak var fourOfAKindButton: UIButton!
    @IBOutlet weak var fullHouseButton: UIButton!
    @IBOutlet weak var smallStraightButton: UIButton!
    @IBOutlet weak var largeStraightButton: UIButton!
    @IBOutlet weak var chanceButton: UIButton!
    @IBOutlet weak var yahtzeeButton: UIButton!
    @IBOutlet weak var totalButton: UIButton!
    
    let dice = [
        UIImage(systemName: "square.fill")!,
        UIImage(systemName: "die.face.1.fill")!,
        UIImage(systemName: "die.face.2.fill")!,
        UIImage(systemName: "die.face.3.fill")!,
        UIImage(systemName: "die.face.4.fill")!,
        UIImage(systemName: "die.face.5.fill")!,
        UIImage(systemName: "die.face.6.fill")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        die1HoldButton.tag = 0
        die2HoldButton.tag = 1
        die3HoldButton.tag = 2
        die4HoldButton.tag = 3
        die5HoldButton.tag = 4
        roundDidEnd()
    }
    
    @IBAction func dieHoldDidPress(_ sender: UIButton) {
        game.toggleHold(sender.tag)
        render(sender)
    }
    
    @IBAction func rollDiceDidPress(_ sender: UIButton) {
        // Clear images to force transition
        if (!game.holds[0]) {
            die1ImageView.image = dice[0]
        }
        if (!game.holds[1]) {
            die2ImageView.image = dice[0]
        }
        if (!game.holds[2]) {
            die3ImageView.image = dice[0]
        }
        if (!game.holds[3]) {
            die4ImageView.image = dice[0]
        }
        if (!game.holds[4]) {
            die5ImageView.image = dice[0]
        }
        game.roll()
        render()
    }
    
    @IBAction func quitDidPress(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func scoreButtonDidPress(_ sender: UIButton) {
        let box = keyPath(for: sender)
        assert(box != nil, "Invalid button press -- no scoring rules")
        assert(game.isRoundStarted, "Must roll at least once to score")
        let _ = game.score(box: box!, dryRun: false)
        sender.isEnabled = false
        roundDidEnd()
    }
    
    
    func roundDidEnd() {
        if game.isGameComplete() {
            let highScore = HighScore(total: game.total!)
            let gameState = AppDelegate.shared.gameState!
            let context = gameState.context!
            context.insert(object: highScore)
            gameState.highScores.append(highScore)
            gameState.currentGame = nil
            context.delete(object: game)
            try! gameState.context!.save()
        } else {
            render()
        }
        
    }
    
    func keyPath(for sender: UIButton) -> ScoreBox? {
        if sender === onesButton { return \.ones }
        if sender === twosButton { return \.twos }
        if sender === threesButton { return \.threes }
        if sender === foursButton { return \.fours }
        if sender === fivesButton { return \.fives }
        if sender === sixesButton { return \.sixes }
//        if sender === bonus { return \.ones }
        if sender === bonusButton { return \.upperBonus }
        if sender === threeOfAKindButton { return \.threeOfAKind }
        if sender === fourOfAKindButton { return \.fourOfAKind }
        if sender === fullHouseButton { return \.fullHouse }
        if sender === smallStraightButton { return \.smallStraight }
        if sender === largeStraightButton { return \.largeStraight }
        if sender === chanceButton { return \.chance }
        if sender === yahtzeeButton { return \.yahtzee }
        if sender === totalButton { return \.total}
        return nil
    }
    
    func render(_ view: UIView? = nil) {
        for button in [onesButton, twosButton, threesButton, foursButton, fivesButton, sixesButton, bonusButton,
                    threeOfAKindButton, fourOfAKindButton, fullHouseButton, smallStraightButton, largeStraightButton, chanceButton, yahtzeeButton, totalButton] {
            guard let button = button else { continue }
            guard let box = keyPath(for: button) else { continue }
            guard let game = game else { continue }
            button.setTitle("\(game[keyPath: box] ?? game.score(box: box, dryRun: true))", for: .normal)
            button.isEnabled = game.isRoundStarted && game[keyPath: box] == nil
        }
        bonusButton.isEnabled = false
        totalButton.isEnabled = false
        die1HoldButton.tintColor = game.holds[0] ? UIColor.systemBlue : UIColor.systemGray
        die2HoldButton.tintColor = game.holds[1] ? UIColor.systemBlue : UIColor.systemGray
        die3HoldButton.tintColor = game.holds[2] ? UIColor.systemBlue : UIColor.systemGray
        die4HoldButton.tintColor = game.holds[3] ? UIColor.systemBlue : UIColor.systemGray
        die5HoldButton.tintColor = game.holds[4] ? UIColor.systemBlue : UIColor.systemGray
        die1ImageView.setSymbolImage(dice[game.rolls[0]], contentTransition: .replace.offUp)
        die2ImageView.setSymbolImage(dice[game.rolls[1]], contentTransition: .replace.offUp)
        die3ImageView.setSymbolImage(dice[game.rolls[2]], contentTransition: .replace.offUp)
        die4ImageView.setSymbolImage(dice[game.rolls[3]], contentTransition: .replace.offUp)
        die5ImageView.setSymbolImage(dice[game.rolls[4]], contentTransition: .replace.offUp)
        rollDiceButton.isUserInteractionEnabled = game.isRollEnabled
        rollDiceButton.setTitle(game.step != 0 ? "Roll (\(game.step) of 3)" : "Roll", for: .normal)
        rollDiceButton.tintColor = game.isRollEnabled ? UIColor.systemBlue : UIColor.systemGray
    }
}

