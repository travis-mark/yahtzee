//
//  ViewController.swift
//  yahtzee
//
//  Created by Travis Luckenbaugh on 6/16/23.
//

import UIKit

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
    
    let dice = [
        UIImage(systemName: "rectangle")!,
        UIImage(systemName: "die.face.1.fill")!,
        UIImage(systemName: "die.face.2.fill")!,
        UIImage(systemName: "die.face.3.fill")!,
        UIImage(systemName: "die.face.4.fill")!,
        UIImage(systemName: "die.face.5.fill")!,
        UIImage(systemName: "die.face.6.fill")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dieHoldDidPress(_ sender: UIButton) {
        sender.tag = sender.tag == 0 ? 1 : 0
        sender.tintColor = sender.tag == 0 ? UIColor.systemGray : UIColor.systemBlue
    }
    
    @IBAction func rollDiceDidPress(_ sender: UIButton) {
        if (die1HoldButton.tag == 0) {
            die1ImageView.tag = Int.random(in: 1...6)
            die1ImageView.image = dice[0] // Clear image, force transition
            die1ImageView.setSymbolImage(dice[die1ImageView.tag], contentTransition: .replace.offUp)
        }
        if (die2HoldButton.tag == 0) {
            die2ImageView.tag = Int.random(in: 1...6)
            die2ImageView.image = dice[0] // Clear image, force transition
            die2ImageView.setSymbolImage(dice[die2ImageView.tag], contentTransition: .replace.offUp)
        }
        if (die3HoldButton.tag == 0) {
            die3ImageView.tag = Int.random(in: 1...6)
            die3ImageView.image = dice[0] // Clear image, force transition
            die3ImageView.setSymbolImage(dice[die3ImageView.tag], contentTransition: .replace.offUp)
        }
        if (die4HoldButton.tag == 0) {
            die4ImageView.tag = Int.random(in: 1...6)
            die4ImageView.image = dice[0] // Clear image, force transition
            die4ImageView.setSymbolImage(dice[die4ImageView.tag], contentTransition: .replace.offUp)
        }
        if (die5HoldButton.tag == 0) {
            die5ImageView.tag = Int.random(in: 1...6)
            die5ImageView.image = dice[0] // Clear image, force transition
            die5ImageView.setSymbolImage(dice[die5ImageView.tag], contentTransition: .replace.offUp)
        }
    }
}

