//
//  ConcentrationGame.swift
//  FlipCards
//
//  Created by Blackwood Martain on 10/31/22.
//

import Foundation

class ConcentrationGame {
    
    private(set) var cards = [Card]()
    
    var gameOver = false
    
    private var indexOfFaceUpCard: Int?
    
    var hideAfterMatchIndex: Int?
    var hideAfterMatchIndex2: Int?
    
    var hideAfterUnmatchIndex: Int?
    var hideAfterUnmatchIndex2: Int?
    
    private var prevButtonIndex: Int?
    
    private func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchingIndex = indexOfFaceUpCard, matchingIndex != index {
                if cards[matchingIndex].identifier == cards[index].identifier {
                    cards[matchingIndex].isMatched = true
                    cards[index].isMatched = true
                    hideAfterMatchIndex = index
                    hideAfterMatchIndex2 = matchingIndex
                } else {
                    hideAfterUnmatchIndex = matchingIndex
                    hideAfterUnmatchIndex2 = index
                }
                cards[index].isFaceUp = true
                indexOfFaceUpCard = nil
            } else {
                for i in cards.indices {
                    cards[i].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfFaceUpCard = index
            }
        }
        
        
    }
    
    init(numsOfPairsOfCards: Int) {
        assert(numsOfPairsOfCards > 0, "init(numsOfPairsOfCards is less then zero)")
        for _ in 1...numsOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
    }
}
