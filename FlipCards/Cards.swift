//
//  Cards.swift
//  FlipCards
//
//  Created by Blackwood Martain on 10/31/22.
//

import Foundation

struct Card {
    var id: Int
    var isMatched = false
    var isFaceUp = false
    
    static var idNumber = 0
    
    static func identifierGen() -> Int {
        idNumber += 1
        return idNumber
    }
    
    init() {
        self.id = Card.identifierGen()
    }
}
