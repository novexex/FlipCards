//
//  ConcentrationGame.swift
//  FlipCards
//
//  Created by Blackwood Martain on 10/31/22.
//

import Foundation

class ConcentrationGame {
    
    var cards = [Card]()
    
    var idOfFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        
    }
    
    init(numsOfPairsOfCards: Int) {
        for _ in 1...numsOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
    }
}
