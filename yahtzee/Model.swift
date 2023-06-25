//  yahtzee - Model.swift
//  Created by Travis Luckenbaugh on 6/22/23.

import Foundation
import SwiftData

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

@Model class ScoreSheet {
    var scores: [Int?]
    
    init(scores: [Int?] = [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]) {
        self.scores = scores
    }
    
    private func count(dice: [Int]) -> [Int] {
        var counts = [0, 0, 0, 0, 0, 0, 0]
        for i in 0 ..< dice.count {
            counts[dice[i]] += 1
        }
        return counts
    }
    
    func value(rolls: [Int], box: ScoreBoxes) -> Int {
        switch box {
        case .ones:
            return rolls.reduce(0, { $0 + ($1 == 1 ? $1 : 0) })
        case .twos:
            return rolls.reduce(0, { $0 + ($1 == 2 ? $1 : 0) })
        case .threes:
            return rolls.reduce(0, { $0 + ($1 == 3 ? $1 : 0) })
        case .fours:
            return rolls.reduce(0, { $0 + ($1 == 4 ? $1 : 0) })
        case .fives:
            return rolls.reduce(0, { $0 + ($1 == 5 ? $1 : 0) })
        case .sixes:
            return rolls.reduce(0, { $0 + ($1 == 6 ? $1 : 0) })
        case .threeOfAKind:
            let counts = count(dice: rolls)
            return counts.max()! >= 3 ? rolls.reduce(0, +) : 0
        case .fourOfAKind:
            let counts = count(dice: rolls)
            return counts.max()! >= 4 ? rolls.reduce(0, +) : 0
        case .smallStraight:
            let mask = rolls.reduce(0, { $0 | 1 << $1 })
            return mask & 30 == 30 || mask & 60 == 60 || mask & 120 == 120 ? 30 : 0
        case .largeStraight:
            let mask = rolls.reduce(0, { $0 | 1 << $1 })
            return mask & 62 == 62 || mask & 124 == 124 ? 40 : 0
        case .fullHouse:
            let counts = count(dice: rolls)
            return counts.contains(3) && counts.contains(2) ? 25 : 0
        case .chance:
            return rolls.reduce(0, +)
        case .yahtzee:
            let counts = count(dice: rolls)
            return counts.contains(5) ? (scores[ScoreBoxes.yahtzee.rawValue] == nil ? 50 : 100) : 0
        default:
            return 0
        }
    }
    
    func isGameComplete() -> Bool {
        // TODO: Redo when scores are layed out
        return scores.filter({ $0 == nil }).count <= 1
    }
}

@Model class Game {
    var sheet: ScoreSheet
    var rolls: [Int]
    var holds: [Bool]
    var step: Int
    
    init() {
        sheet = ScoreSheet()
        rolls = [0,0,0,0,0]
        holds = [false, false, false, false, false]
        step = 0
    }
    
    var isRollEnabled: Bool {
        return step < 3 && !sheet.isGameComplete()
    }
    
    func roll() {
        assert(isRollEnabled)
        assert(holds.count == rolls.count)
        for i in 0..<holds.count {
            if (holds[i] == false) {
                rolls[i] = Int.random(in: 1...6)
            }
        }
        step = step + 1
    }
    
    func toggleHold(_ index: Int) {
        assert(index < holds.count)
        holds[index] = !holds[index]
    }
    
    func score(box: ScoreBoxes) {
        sheet.scores[box.rawValue] = sheet.value(rolls: rolls, box: box)
        if (box.rawValue <= ScoreBoxes.sixes.rawValue && sheet.scores[ScoreBoxes.bonus.rawValue] == nil) {
            if let ones = sheet.scores[ScoreBoxes.ones.rawValue],
               let twos = sheet.scores[ScoreBoxes.twos.rawValue],
               let three = sheet.scores[ScoreBoxes.threes.rawValue],
               let fours = sheet.scores[ScoreBoxes.fours.rawValue],
               let fives = sheet.scores[ScoreBoxes.fives.rawValue],
               let sixes = sheet.scores[ScoreBoxes.sixes.rawValue] {
                let subtotal = ones + twos + three + fours + fives + sixes
                sheet.scores[ScoreBoxes.bonus.rawValue] = subtotal >= 63 ? 35 : 0
            }
        }
        sheet.scores[ScoreBoxes.total.rawValue] = sheet.scores[0..<ScoreBoxes.total.rawValue].reduce(0, { $0 + ($1 ?? 0 ) })
        holds = [false, false, false, false, false]
        step = 0
    }
}

@Model class GameState {
    var currentGame: Game?
    var highScores: [ScoreSheet]
    
    init() {
        currentGame = nil
        highScores = []
    }
}



@MainActor func startNewGame() -> Game {
    let oldGame = AppDelegate.shared.gameState.currentGame
    let oldGameContext = oldGame?.context
    let newGame = Game()
    let newGameContext = AppDelegate.shared.gameState.context
    // Delete previous game if found
    if let oldGame = oldGame, let oldGameContext = oldGameContext {
        assert(oldGameContext == newGameContext)
        oldGameContext.delete(object: oldGame)
    }
    // Save new game to database if in not inside a test
    if let newGameContext = newGameContext {
        do {
            newGameContext.insert(newGame)
            try newGameContext.save()
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    AppDelegate.shared.gameState.currentGame = newGame
    return newGame
}
