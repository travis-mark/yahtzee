//
//  ViewController.swift
//  yahtzee
//
//  Created by Travis Luckenbaugh on 6/16/23.
//

import UIKit

// TODO: Game complete / reset
// TODO: Add title screen (New Game, Continue) -> (Roll, Quit)

enum ScoreBoxes: Int {
    case ones = 1
    case twos = 2
    case threes = 3
    case fours = 4
    case fives = 5
    case sixes = 6
    case bonus = 7
    case threeOfAKind = 8
    case fourOfAKind = 9
    case fullHouse = 10
    case smallStraight = 11
    case largeStraight = 12
    case chance = 13
    case yahtzee = 14
    case total = 15
}

func count(dice: [Int]) -> [Int] {
    var counts = [0, 0, 0, 0, 0, 0, 0]
    for i in 0 ..< dice.count {
        counts[dice[i]] += 1
    }
    return counts
}

func score(dice: [Int], for box: ScoreBoxes) -> Int {
    switch box {
    case .ones:
        return dice.reduce(0, { $0 + ($1 == 1 ? $1 : 0) })
    case .twos:
        return dice.reduce(0, { $0 + ($1 == 2 ? $1 : 0) })
    case .threes:
        return dice.reduce(0, { $0 + ($1 == 3 ? $1 : 0) })
    case .fours:
        return dice.reduce(0, { $0 + ($1 == 4 ? $1 : 0) })
    case .fives:
        return dice.reduce(0, { $0 + ($1 == 5 ? $1 : 0) })
    case .sixes:
        return dice.reduce(0, { $0 + ($1 == 6 ? $1 : 0) })
    case .threeOfAKind:
        let counts = count(dice: dice)
        return counts.max()! >= 3 ? dice.reduce(0, +) : 0
    case .fourOfAKind:
        let counts = count(dice: dice)
        return counts.max()! >= 4 ? dice.reduce(0, +) : 0
    case .smallStraight:
        let mask = dice.reduce(0, { $0 | 1 << $1 })
        return mask & 30 == 30 || mask & 60 == 60 || mask & 120 == 120 ? 30 : 0
    case .largeStraight:
        let mask = dice.reduce(0, { $0 | 1 << $1 })
        return mask & 62 == 62 || mask & 124 == 124 ? 40 : 0
    case .fullHouse:
        let counts = count(dice: dice)
        return counts.contains(3) && counts.contains(2) ? 25 : 0
    case .chance:
        return dice.reduce(0, +)
    case .yahtzee:
        // TODO: Yahtzee bonus 100
        let counts = count(dice: dice)
        return counts.contains(5) ? 50 : 0
    default:
        return 0
    }
}

class ViewController: UIViewController {
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
    @IBOutlet weak var rollCountLabel: UILabel!
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
            die1ImageView.tag = Int.random(in: 1...6)
            die1ImageView.image = dice[0] // Clear image, force transition
        }
        if (die2HoldButton.tag == 0) {
            die2ImageView.tag = Int.random(in: 1...6)
            die2ImageView.image = dice[0] // Clear image, force transition
        }
        if (die3HoldButton.tag == 0) {
            die3ImageView.tag = Int.random(in: 1...6)
            die3ImageView.image = dice[0] // Clear image, force transition
        }
        if (die4HoldButton.tag == 0) {
            die4ImageView.tag = Int.random(in: 1...6)
            die4ImageView.image = dice[0] // Clear image, force transition
        }
        if (die5HoldButton.tag == 0) {
            die5ImageView.tag = Int.random(in: 1...6)
            die5ImageView.image = dice[0] // Clear image, force transition
        }
        rollCountLabel.tag = rollCountLabel.tag + 1
        render()
    }
    
    @IBAction func scoreButtonDidPress(_ sender: UIButton) {
        guard let box = ScoreBoxes(rawValue: sender.tag) else {
            NSLog("Invalid button press -- no scoring rules")
            return
        }
        guard rollCountLabel.tag > 0 else {
            NSLog("Must roll at least once to score")
            return
        }
        let dice = [die1ImageView.tag, die2ImageView.tag, die3ImageView.tag, die4ImageView.tag, die5ImageView.tag]
        sender.setTitle("\(score(dice: dice, for: box))", for: .normal)
        roundDidEnd()
    }
    
    
    func roundDidEnd() {
        die1HoldButton.tag = 0
        die2HoldButton.tag = 0
        die3HoldButton.tag = 0
        die4HoldButton.tag = 0
        die5HoldButton.tag = 0
        rollCountLabel.tag = 0
        render()
    }
    
    func render(_ view: UIView? = nil) {
        die1HoldButton.tintColor = die1HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die2HoldButton.tintColor = die2HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die3HoldButton.tintColor = die3HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die4HoldButton.tintColor = die4HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die5HoldButton.tintColor = die5HoldButton.tag != 0 ? UIColor.systemBlue : UIColor.systemGray
        die1ImageView.setSymbolImage(dice[die1ImageView.tag], contentTransition: .replace.offUp)
        die2ImageView.setSymbolImage(dice[die2ImageView.tag], contentTransition: .replace.offUp)
        die3ImageView.setSymbolImage(dice[die3ImageView.tag], contentTransition: .replace.offUp)
        die4ImageView.setSymbolImage(dice[die4ImageView.tag], contentTransition: .replace.offUp)
        die5ImageView.setSymbolImage(dice[die5ImageView.tag], contentTransition: .replace.offUp)
        rollDiceButton.tintColor = rollCountLabel.tag < 3 ? UIColor.systemBlue : UIColor.systemGray
        rollDiceButton.isUserInteractionEnabled = rollCountLabel.tag < 3
        rollCountLabel.text = rollCountLabel.tag != 0 ? "\(rollCountLabel.tag) of 3" : ""
    }
}

