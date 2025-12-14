//
//  ScoreManager.swift
//  Cards
//
//  Created by Vadim on 14/12/2025.
//

class ScoreManager {

    private(set) var score: Int = 0

    func matchedPair() {
        score += 10
    }

    func mismatch() {
        score = max(0, score - 2)
    }

    func usedHint() {
        score = max(0, score - 5)
    }

    func reset() {
        score = 0
    }
}
