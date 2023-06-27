//  yahtzee - Model.swift
//  Created by Travis Luckenbaugh on 6/22/23.

import Foundation
import SwiftData

@Model class Game {
    var ones: Int?
    var twos: Int?
    var threes: Int?
    var fours: Int?
    var fives: Int?
    var sixes: Int?
    var subtotal: Int?
    var bonus: Int?
    var threeOfAKind: Int?
    var fourOfAKind: Int?
    var fullHouse: Int?
    var smallStraight: Int?
    var largeStraight: Int?
    var chance: Int?
    var yahtzee: Int?
    var total: Int?
    var rolls: [Int]
    var holds: [Bool]
    var step: Int
    
    init() {
        rolls = [0,0,0,0,0]
        holds = [false, false, false, false, false]
        step = 0
    }
    
    var isRoundStarted: Bool {
        return step > 0
    }
    
    var isRollEnabled: Bool {
        return step < 3 && !isGameComplete()
    }
    
    private func count(dice: [Int]) -> [Int] {
        var counts = [0, 0, 0, 0, 0, 0, 0]
        for i in 0 ..< dice.count {
            counts[dice[i]] += 1
        }
        return counts
    }
    
    func value(rolls: [Int], box: KeyPath<Game, Int?>) -> Int {
        switch box {
        case \.ones:
            return rolls.reduce(0, { $0 + ($1 == 1 ? $1 : 0) })
        case \.twos:
            return rolls.reduce(0, { $0 + ($1 == 2 ? $1 : 0) })
        case \.threes:
            return rolls.reduce(0, { $0 + ($1 == 3 ? $1 : 0) })
        case \.fours:
            return rolls.reduce(0, { $0 + ($1 == 4 ? $1 : 0) })
        case \.fives:
            return rolls.reduce(0, { $0 + ($1 == 5 ? $1 : 0) })
        case \.sixes:
            return rolls.reduce(0, { $0 + ($1 == 6 ? $1 : 0) })
        case \.threeOfAKind:
            let counts = count(dice: rolls)
            return counts.max()! >= 3 ? rolls.reduce(0, +) : 0
        case \.fourOfAKind:
            let counts = count(dice: rolls)
            return counts.max()! >= 4 ? rolls.reduce(0, +) : 0
        case \.smallStraight:
            let mask = rolls.reduce(0, { $0 | 1 << $1 })
            return mask & 30 == 30 || mask & 60 == 60 || mask & 120 == 120 ? 30 : 0
        case \.largeStraight:
            let mask = rolls.reduce(0, { $0 | 1 << $1 })
            return mask & 62 == 62 || mask & 124 == 124 ? 40 : 0
        case \.fullHouse:
            let counts = count(dice: rolls)
            return counts.contains(3) && counts.contains(2) ? 25 : 0
        case \.chance:
            return rolls.reduce(0, +)
        case \.yahtzee:
            let counts = count(dice: rolls)
            return counts.contains(5) ? (yahtzee == nil ? 50 : 100) : 0
        case \.total:
            return total ?? 0
        default:
            return 0
        }
    }
    
    func isGameComplete() -> Bool {
        if ones == nil { return false }
        if twos == nil { return false }
        if threes == nil { return false }
        if fours == nil { return false }
        if fives == nil { return false }
        if sixes == nil { return false }
        if threeOfAKind == nil { return false }
        if fourOfAKind == nil { return false }
        if fullHouse == nil { return false }
        if smallStraight == nil { return false }
        if largeStraight == nil { return false }
        if chance == nil { return false }
        if yahtzee == nil { return false }
        return true
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
    
    func score(box: KeyPath<Game, Int?>) {
        switch box {
        case \.ones:
            let value = value(rolls: rolls, box: box)
            ones = value
            subtotal = subtotal ?? 0 + value
            total = total ?? 0 + value
        case \.twos:
            let value = value(rolls: rolls, box: box)
            twos = value
            subtotal = subtotal ?? 0 + value
            total = total ?? 0 + value
        case \.threes:
            let value = value(rolls: rolls, box: box)
            threes = value
            subtotal = subtotal ?? 0 + value
            total = total ?? 0 + value
        case \.fours:
            let value = value(rolls: rolls, box: box)
            fours = value
            subtotal = subtotal ?? 0 + value
            total = total ?? 0 + value
        case \.fives:
            let value = value(rolls: rolls, box: box)
            fives = value
            subtotal = subtotal ?? 0 + value
            total = total ?? 0 + value
        case \.sixes:
            let value = value(rolls: rolls, box: box)
            sixes = value
            subtotal = subtotal ?? 0 + value
            total = total ?? 0 + value
        case \.bonus:
            let value = subtotal ?? 0 >= 63 ? 35 : 0
            bonus = value
            total = total ?? 0 + value
        case \.threeOfAKind:
            let value = value(rolls: rolls, box: box)
            threeOfAKind = value
            total = total ?? 0 + value
        case \.fourOfAKind:
            let value = value(rolls: rolls, box: box)
            fourOfAKind = value
            total = total ?? 0 + value
        case \.fullHouse:
            let value = value(rolls: rolls, box: box)
            fullHouse = value
            total = total ?? 0 + value
        case \.smallStraight:
            let value = value(rolls: rolls, box: box)
            smallStraight = value
            total = total ?? 0 + value
        case \.largeStraight:
            let value = value(rolls: rolls, box: box)
            largeStraight = value
            total = total ?? 0 + value
        case \.chance:
            let value = value(rolls: rolls, box: box)
            chance = value
            total = total ?? 0 + value
        case \.yahtzee:
            let value = value(rolls: rolls, box: box)
            yahtzee = value
            total = total ?? 0 + value
        default:
            break
        }
        if bonus == nil,
           ones != nil,
           twos != nil,
           threes != nil,
           fours != nil,
           fives != nil,
           sixes != nil
        {
            score(box: \.bonus)
        }
        holds = [false, false, false, false, false]
        step = 0
    }
}

@Model class HighScore {
    var total: Int
    
    init(total: Int) {
        self.total = total
    }
}

@Model class GameState {
    var currentGame: Game?
    var highScores: [HighScore]
    
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
            log.error("Save new Game failed :: \(error.localizedDescription, privacy: .public)")
        }
    }
    AppDelegate.shared.gameState.currentGame = newGame
    return newGame
}
