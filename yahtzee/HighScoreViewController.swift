//  yahtzee - HighScoreViewController.swift
//  Created by Travis Luckenbaugh on 6/23/23.

import UIKit

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var topGames: [HighScore] = [] { didSet {
        guard isViewLoaded else { return }
        tableView.reloadData()
    }}
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GameScoreCell")
    }
                                   
    @IBAction func closeDidPress(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameScoreCell", for: indexPath)
        cell.textLabel?.text = "\(topGames[indexPath.row].total)"
        return cell
    }
}
