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
    var upperBonus: Int?
    var threeOfAKind: Int?
    var fourOfAKind: Int?
    var fullHouse: Int?
    var smallStraight: Int?
    var largeStraight: Int?
    var chance: Int?
    var yahtzee: Int?
    var lowerBonus: Int?
    var total: Int?
    var rolls: [Int]
    var holds: [Bool]
    var step: Int
    
    init() {
        rolls = [0,0,0,0,0]
        holds = [false, false, false, false, false]
        step = 0
        lowerBonus = 0
    }
    
    // TODO: Try to write a Swift macro to make bookkeeping easier
    @Transient private var _counts: [Int]?
    private var counts: [Int] {
        if let cached = _counts { return cached }
        var counts = [0, 0, 0, 0, 0, 0, 0]
        for i in 0 ..< rolls.count {
            let value = rolls[i]
            if value != 0 {
                counts[value] += 1
            }
        }
        _counts = counts
        return counts
    }
}

typealias ScoreBox = WritableKeyPath<Game, Int?>

func addUp(_ scores: Int?...) -> Int {
    return scores.reduce(0, { $0 + ($1 ?? 0)})
}

extension Game {
    var isRoundStarted: Bool {
        return step > 0
    }
    
    var isRollEnabled: Bool {
        return step < 3 && !isGameComplete()
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
        _counts = nil
        step = step + 1
    }
    
    func toggleHold(_ index: Int) {
        assert(index < holds.count)
        holds[index] = !holds[index]
    }
    
    func score(box: ScoreBox, dryRun: Bool) -> Int {
        let isYahtzee = counts.contains(5)
        let isJoker = isYahtzee && yahtzee != nil
        // Swift 5.9 switch-as-expr feels out of place with the language
        // Case blocks with multiple statements still require lambda-with-return
        let value: Int =
        switch box {
        case \.ones:
            rolls.reduce(0, { $0 + ($1 == 1 ? $1 : 0) })
        case \.twos:
            rolls.reduce(0, { $0 + ($1 == 2 ? $1 : 0) })
        case \.threes:
            rolls.reduce(0, { $0 + ($1 == 3 ? $1 : 0) })
        case \.fours:
            rolls.reduce(0, { $0 + ($1 == 4 ? $1 : 0) })
        case \.fives:
            rolls.reduce(0, { $0 + ($1 == 5 ? $1 : 0) })
        case \.sixes:
            rolls.reduce(0, { $0 + ($1 == 6 ? $1 : 0) })
        case \.threeOfAKind:
            isJoker || counts.max()! >= 3 ? rolls.reduce(0, +) : 0
        case \.fourOfAKind:
            isJoker || counts.max()! >= 4 ? rolls.reduce(0, +) : 0
        case \.smallStraight: {
            let mask = rolls.reduce(0, { $0 | 1 << $1 })
            return isJoker || mask & 30 == 30 || mask & 60 == 60 || mask & 120 == 120 ? 30 : 0
        }()
        case \.largeStraight: {
            let mask = rolls.reduce(0, { $0 | 1 << $1 })
            return isJoker || mask & 62 == 62 || mask & 124 == 124 ? 40 : 0
        }()
        case \.fullHouse:
            isJoker || counts.contains(3) && counts.contains(2) ? 25 : 0
        case \.chance:
            rolls.reduce(0, +)
        case \.yahtzee:
            isYahtzee ? 50 : 0
        default:
            0
        }
        if !dryRun {
            setValue(for: box, to: value)
            subtotal = addUp(ones, twos, threes, fours, fives, sixes)
            upperBonus = subtotal! > 63 ? 35 : 0
            if isJoker && yahtzee == 50 {
                lowerBonus = (lowerBonus ?? 0) + 100
            }
            total = addUp(subtotal, upperBonus, threeOfAKind, fourOfAKind, fullHouse, smallStraight, largeStraight, chance, yahtzee, lowerBonus)
            holds = [false, false, false, false, false]
            step = 0
        }
        return value
    }
}

@Model class HighScore {
    var total: Int
    var date: Date
    
    init(total: Int, date: Date) {
        self.total = total
        self.date = date
    }
}

@MainActor func startNewGame() -> Game {
    let context = AppDelegate.shared.container.mainContext
    do {
        // Delete previous game if found
        let descriptor = FetchDescriptor<Game>()
        let oldGames = try context.fetch(descriptor) // Should only be 1
        for oldGame in oldGames {
            context.delete(oldGame)
        }
        // Save new game to database
        let newGame = Game()
        context.insert(newGame)
        try context.save()
        return newGame
    } catch {
        log.error("Save new Game failed :: \(error.localizedDescription, privacy: .public)")
        abort()
    }
}

@MainActor func fetchCurrentGame() -> Game? {
    let context = AppDelegate.shared.container.mainContext
    let descriptor = FetchDescriptor<Game>()
    return try? context.fetch(descriptor).first
}

@MainActor func fetchHighScores(_ limit: Int? = 5) -> [HighScore] {
    let context = AppDelegate.shared.container.mainContext
    var descriptor = FetchDescriptor<HighScore>()
    descriptor.fetchLimit = 5
    descriptor.sortBy = [SortDescriptor(\.total, order: .reverse)]
    return (try? context.fetch(descriptor)) ?? []
}
