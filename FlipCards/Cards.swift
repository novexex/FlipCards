//
//  Cards.swift
//  FlipCards
//
//  Created by Blackwood Martain on 10/31/22.
//

import Foundation

struct Card {
    var identifier: Int
    var isMatched = false
    var isFaceUp = false
    
    private static var index = 0
    
    private static func identifierGen() -> Int {
        index += 1
        return index
    }
    
    init() {
        self.identifier = Card.identifierGen()
    }
}
