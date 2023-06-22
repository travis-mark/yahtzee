//  yahtzee - GameViewController.swift
//  Created by Travis Luckenbaugh on 6/16/23.

import UIKit

// TODO: Game complete / reset

class GameViewController: UIViewController {
    var sheet: ScoreSheet!
    
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
        
        onesButton.tag = ScoreBoxes.ones.rawValue
        twosButton.tag = ScoreBoxes.twos.rawValue
        threesButton.tag = ScoreBoxes.threes.rawValue
        foursButton.tag = ScoreBoxes.fours.rawValue
        fivesButton.tag = ScoreBoxes.fives.rawValue
        sixesButton.tag = ScoreBoxes.sixes.rawValue
        bonusButton.tag = ScoreBoxes.bonus.rawValue
        threeOfAKindButton.tag = ScoreBoxes.threeOfAKind.rawValue
        fourOfAKindButton.tag = ScoreBoxes.fourOfAKind.rawValue
        fullHouseButton.tag = ScoreBoxes.fullHouse.rawValue
        smallStraightButton.tag = ScoreBoxes.smallStraight.rawValue
        largeStraightButton.tag = ScoreBoxes.largeStraight.rawValue
        chanceButton.tag = ScoreBoxes.chance.rawValue
        yahtzeeButton.tag = ScoreBoxes.yahtzee.rawValue
        totalButton.tag = ScoreBoxes.total.rawValue
        
        roundDidEnd()
    }
    
    @IBAction func dieHoldDidPress(_ sender: UIButton) {
        sender.tag = sender.tag == 0 ? 1 : 0
        render(sender)
    }
    
    @IBAction func rollDiceDidPress(_ sender: UIButton) {
        if (die1HoldButton.tag == 0) {
            sheet.rolls[0] = Int.random(in: 1...6)
            die1ImageView.image = dice[0] // Clear image, force transition
        }
        if (die2HoldButton.tag == 0) {
            sheet.rolls[1] = Int.random(in: 1...6)
            die2ImageView.image = dice[0] // Clear image, force transition
        }
        if (die3HoldButton.tag == 0) {
            sheet.rolls[2] = Int.random(in: 1...6)
            die3ImageView.image = dice[0] // Clear image, force transition
        }
        if (die4HoldButton.tag == 0) {
            sheet.rolls[3] = Int.random(in: 1...6)
            die4ImageView.image = dice[0] // Clear image, force transition
        }
        if (die5HoldButton.tag == 0) {
            sheet.rolls[4] = Int.random(in: 1...6)
            die5ImageView.image = dice[0] // Clear image, force transition
        }
        sheet.step = sheet.step + 1
        render()
    }
    
    @IBAction func quitDidPress(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func scoreButtonDidPress(_ sender: UIButton) {
        guard let box = ScoreBoxes(rawValue: sender.tag) else {
            NSLog("Invalid button press -- no scoring rules")
            return
        }
        guard sheet.step > 0 else {
            NSLog("Must roll at least once to score")
            return
        }
        sheet.score(box: box)
        roundDidEnd()
    }
    
    
    func roundDidEnd() {
        die1HoldButton.tag = 0
        die2HoldButton.tag = 0
        die3HoldButton.tag = 0
        die4HoldButton.tag = 0
        die5HoldButton.tag = 0
        sheet.step = 0
        render()
    }
    
    func render(_ view: UIView? = nil) {
        for button in [onesButton, twosButton, threesButton, foursButton, fivesButton, sixesButton, bonusButton,
                    threeOfAKindButton, fourOfAKindButton, fullHouseButton, smallStraightButton, largeStraightButton, chanceButton, yahtzeeButton, totalButton] {
            guard let button = button, let box = ScoreBoxes(rawValue: button.tag) else { continue }
            button.setTitle("\(sheet.scores[button.tag] ?? sheet.value(box: box))", for: .normal)
            button.isEnabled = sheet.scores[button.tag] == nil
        }
        bonusButton.isEnabled = false
        totalButton.isEnabled = false
        die1HoldButton.tintColor = die1HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die2HoldButton.tintColor = die2HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die3HoldButton.tintColor = die3HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die4HoldButton.tintColor = die4HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die5HoldButton.tintColor = die5HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die1ImageView.setSymbolImage(dice[sheet.rolls[0]], contentTransition: .replace.offUp)
        die2ImageView.setSymbolImage(dice[sheet.rolls[1]], contentTransition: .replace.offUp)
        die3ImageView.setSymbolImage(dice[sheet.rolls[2]], contentTransition: .replace.offUp)
        die4ImageView.setSymbolImage(dice[sheet.rolls[3]], contentTransition: .replace.offUp)
        die5ImageView.setSymbolImage(dice[sheet.rolls[4]], contentTransition: .replace.offUp)
        rollDiceButton.isUserInteractionEnabled = sheet.step < 3
        rollDiceButton.setTitle(sheet.step != 0 ? "Roll (\(sheet.step) of 3)" : "Roll", for: .normal)
        rollDiceButton.tintColor = sheet.step < 3 ? UIColor.systemBlue : UIColor.systemGray
    }
}

