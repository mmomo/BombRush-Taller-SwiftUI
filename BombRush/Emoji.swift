//
//  Emoji.swift
//  BombRush
//
//  Created by César Venzor on 21/10/25.
//

import Foundation

struct Emoji: Identifiable {
    let id = UUID()
    let emoji: String
    let isBomb: Bool
    var isTapped: Bool = false
}
