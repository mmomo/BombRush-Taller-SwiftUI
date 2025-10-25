//
//  GameViewModel.swift
//  BombRush
//
//  Created by César Venzor on 21/10/25.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var emojis: [Emoji] = []
    @Published var score: Int = 0
    @Published var gameOver = false
    @Published var level = 1
    @Published var explodedEmojiID: UUID? = nil
    @Published var timeRemaining = 5.0

    private let safeEmojis = ["🎃", "👻", "🦴", "🕸️", "👽", "🐈‍⬛", "💐", "🦞"]
    private let bombEmoji = "💣"
    
    private var timer: Timer?

    
    func startGame() {
        score = 0
        level = 1
        explodedEmojiID = nil
        startLevel()
    }
    
    func startLevel() {
        generateEmojis()
        timeRemaining = 5.0
        startTimer()
    }
    
    func nextLevel() {
        level += 1
        startLevel()
    }
    
    func stopGame() {
        timer?.invalidate()
        gameOver = true
        explodedEmojiID = nil
    }
    
    private func generateEmojis() {
        emojis = []
        
        let gridSize = 4
        let totalEmojis = gridSize * gridSize
        let totalBombs = Int.random(in: 4...9)
        
        var tempEmojis: [Emoji] = []
        
        for _ in 0..<totalBombs {
            let bomb = Emoji(emoji: bombEmoji, isBomb: true)
            
            tempEmojis.append(bomb)
        }
        
        for _ in 0..<(totalEmojis - totalBombs) {
            let emoji = Emoji(emoji: safeEmojis.randomElement()!, isBomb: false)
            
            tempEmojis.append(emoji)
        }
        
        tempEmojis.shuffle()
        emojis = tempEmojis
    
    }
    
    
    func tap(_ emoji: Emoji) {
        // Find the tapped emoji in the array to mark it as tapped
        guard let index = emojis.firstIndex(where: { $0.id == emoji.id }) else { return }
        
        if emoji.isBomb {
            explodedEmojiID = emoji.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.stopGame()
            }
            
        } else {
            emojis[index].isTapped = true
            score += 1
            
            if emojis.allSatisfy({ $0.isTapped || $0.isBomb }) {
                nextLevel()
            }
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 0.1
            } else {
                self.stopGame()
            }
        }
    }
}
