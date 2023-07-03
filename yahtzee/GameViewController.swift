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
    
    let dice: [UIImage] = {
        let configuration = UIImage.SymbolConfiguration(paletteColors: [.white, .accent])
        return [
            UIImage(systemName: "square.fill")!,
            UIImage(systemName: "die.face.1.fill", withConfiguration: configuration)!,
            UIImage(systemName: "die.face.2.fill", withConfiguration: configuration)!,
            UIImage(systemName: "die.face.3.fill", withConfiguration: configuration)!,
            UIImage(systemName: "die.face.4.fill", withConfiguration: configuration)!,
            UIImage(systemName: "die.face.5.fill", withConfiguration: configuration)!,
            UIImage(systemName: "die.face.6.fill", withConfiguration: configuration)!
        ]
    }()
    
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
        guard let box = keyPath(for: sender) else {
            assert(false, "Invalid button press -- no scoring rules")
            return
        }
        guard game.canScore(box: box) else {
            assert(false, "Must roll at least once to score")
            return
        }
        let _ = game.score(box: box, dryRun: false)
        roundDidEnd()
    }
    
    func roundDidEnd() {
        render()
        
        if game.isGameComplete(), let total = game.total {
            let highScore = HighScore(total: total, date: Date())
            let context = game.context!
            context.insert(object: highScore)
            context.delete(object: game)
            try! context.save()
        }
    }
    
    func keyPath(for sender: UIButton) -> ScoreBox? {
        if sender === onesButton { return \.ones }
        if sender === twosButton { return \.twos }
        if sender === threesButton { return \.threes }
        if sender === foursButton { return \.fours }
        if sender === fivesButton { return \.fives }
        if sender === sixesButton { return \.sixes }
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
            if let existing = game[keyPath: box] {
                button.configuration = UIButton.Configuration.plain()
                button.setTitle("\(existing)", for: .normal)
                button.isEnabled = true
                button.isUserInteractionEnabled = false
            } else {
                button.configuration = UIButton.Configuration.filled()
                if game.canScore(box: box) {
                    button.setTitle("\(game.score(box: box, dryRun: true))", for: .normal)
                    button.isEnabled = true
                    button.isUserInteractionEnabled = true
                } else {
                    button.setTitle("--", for: .normal)
                    button.isEnabled = false
                    button.isUserInteractionEnabled = false
                }
            }
        }
        bonusButton.isEnabled = false
        totalButton.isEnabled = false
        die1HoldButton.tintColor = game.holds[0] ? .accent : .darkGray
        die2HoldButton.tintColor = game.holds[1] ? .accent : .darkGray
        die3HoldButton.tintColor = game.holds[2] ? .accent : .darkGray
        die4HoldButton.tintColor = game.holds[3] ? .accent : .darkGray
        die5HoldButton.tintColor = game.holds[4] ? .accent : .darkGray
        die1ImageView.setSymbolImage(dice[game.rolls[0]], contentTransition: .replace.offUp)
        die2ImageView.setSymbolImage(dice[game.rolls[1]], contentTransition: .replace.offUp)
        die3ImageView.setSymbolImage(dice[game.rolls[2]], contentTransition: .replace.offUp)
        die4ImageView.setSymbolImage(dice[game.rolls[3]], contentTransition: .replace.offUp)
        die5ImageView.setSymbolImage(dice[game.rolls[4]], contentTransition: .replace.offUp)
        rollDiceButton.isUserInteractionEnabled = game.isRollEnabled
        rollDiceButton.setTitle(game.step != 0 ? "Roll (\(game.step) of 3)" : "Roll", for: .normal)
        rollDiceButton.tintColor = game.isRollEnabled ? .accent : .darkGray
    }
}

