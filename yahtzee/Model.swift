//  yahtzee - Model.swift
//  Created by Travis Luckenbaugh on 6/22/23.

import Foundation
import SwiftData

let container = try! ModelContainer(for: ScoreSheet.self)

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
    var rolls: [Int]
    var step: Int
    
    init(scores: [Int?] = [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil], rolls: [Int] = [0,0,0,0,0], step: Int = 0) {
        self.scores = scores
        self.rolls = rolls
        self.step = step
    }
    
    private func count(dice: [Int]) -> [Int] {
        var counts = [0, 0, 0, 0, 0, 0, 0]
        for i in 0 ..< dice.count {
            counts[dice[i]] += 1
        }
        return counts
    }
    
    func value(box: ScoreBoxes) -> Int {
        guard step > 0 else {
            return 0
        }
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
    
    func score(box: ScoreBoxes) {
        self.scores[box.rawValue] = value(box: box)
        if (box.rawValue <= ScoreBoxes.sixes.rawValue && self.scores[ScoreBoxes.bonus.rawValue] == nil) {
            if let ones = self.scores[ScoreBoxes.ones.rawValue],
               let twos = self.scores[ScoreBoxes.twos.rawValue],
               let three = self.scores[ScoreBoxes.threes.rawValue],
               let fours = self.scores[ScoreBoxes.fours.rawValue],
               let fives = self.scores[ScoreBoxes.fives.rawValue],
               let sixes = self.scores[ScoreBoxes.sixes.rawValue] {
                let subtotal = ones + twos + three + fours + fives + sixes
                self.scores[ScoreBoxes.bonus.rawValue] = subtotal >= 63 ? 35 : 0
            }
        }
        self.scores[ScoreBoxes.total.rawValue] = self.scores[0..<ScoreBoxes.total.rawValue].reduce(0, { $0 + ($1 ?? 0 ) })
    }
}

@MainActor func getCurrentScoreSheet() -> ScoreSheet? {
    do {
        let descriptor = FetchDescriptor<ScoreSheet>()
        let context = container.mainContext
        return try context.fetch(descriptor).first
    } catch {
        NSLog(error.localizedDescription)
        return nil
    }
}

@MainActor func startNewGame() -> ScoreSheet {
    let context = container.mainContext
    if let oldGame = getCurrentScoreSheet() {
        context.delete(object: oldGame)
    }
    let object = ScoreSheet()
    context.insert(object)
    try! context.save()
    return object
}
