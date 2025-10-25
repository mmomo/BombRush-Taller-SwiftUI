//
//  ContentView.swift
//  BombRush
//
//  Created by César Venzor on 21/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    // This creates 4 flexible columns that fill the available width.
    let fourColumns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        VStack {
            Text("BombRush 💣")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            HStack(spacing: 50) {
                Text("Puntos: \(viewModel.score)")
                    .font(.headline)
                
                Text("Nivel: \(viewModel.level)")
                    .font(.headline)
                
            }
            
            Text(String(format: "Tiempo: %.1f s", viewModel.timeRemaining))
                .font(.headline)
                .foregroundStyle(viewModel.timeRemaining < 2 ? .red : .black)
            
            LazyVGrid(columns: fourColumns, spacing: 20) {
                ForEach(viewModel.emojis) { currentEmoji in
                    if viewModel.explodedEmojiID == currentEmoji.id {
                        ExplosionAnimationView()
                    } else {
                        
                        EmojiView(emoji: currentEmoji) {
                            viewModel.tap(currentEmoji)
                        }
                    }
                }
            }
            .padding()
                  
            Spacer()
            
            Button("Reiniciar") {
                viewModel.startGame()
            }
            
            Spacer()

        }
        .alert("Fin del juego", isPresented: $viewModel.gameOver, actions: {
            Button("Reiniciar", action: viewModel.startGame)
        }, message: {
            Text("Puntuación final: \(viewModel.score)\nNiveles completados: \(viewModel.level)")
        })
        .onAppear {
            viewModel.startGame()
        }
    }
}

// MARK: - Simple Explosion Animation
struct ExplosionAnimationView: View {
    @State private var explode = false
    
    var body: some View {
        Text("💥")
            .font(.system(size: 50))
            .scaleEffect(explode ? 3 : 1)
            .opacity(explode ? 0 : 1)
            .animation(.easeOut(duration: 0.5), value: explode)
            .onAppear {
                explode = true
            }
    }
}

// MARK: - Simple Emoji View
struct EmojiView: View {
    let emoji: Emoji
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(emoji.emoji)
                .font(.system(size: 50))
                .opacity(emoji.isTapped ? 0.3 : 1.0)
                .scaleEffect(emoji.isTapped ? 0.8 : 1.0)
                .scaleEffect(emoji.isTapped && emoji.isBomb ? 1.6 : 1.0)
        }
        .disabled(emoji.isTapped)
    }
}

#Preview {
    ContentView()
}
