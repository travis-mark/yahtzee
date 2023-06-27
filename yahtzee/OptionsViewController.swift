//  yahtzee - OptionsViewController.swift
//  Created by Travis Luckenbaugh on 6/24/23.

import UIKit

class OptionsViewController: UIViewController {
    @IBOutlet weak var backgroundColorWell: UIColorWell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColorWell.addTarget(self, action: #selector(backgroundColorWellValueDidChange(_:)), for: .valueChanged)
    }
    
    @IBAction func closeDidPress(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func backgroundColorWellValueDidChange(_ sender: Any) {
        let color = backgroundColorWell.selectedColor?.description ?? "nil"
        log.info("Background color set = \(color, privacy: .private)")
    }
}
