//
//  ConcentrationGame.swift
//  FlipCards
//
//  Created by Blackwood Martain on 10/31/22.
//

import Foundation

class ConcentrationGame {
    
    var cards = [Card]()
    
    var gameOver = false
    
    var indexOfFaceUpCard: Int?
    
    var hideAfterMatchIndex: Int?
    var hideAfterMatchIndex2: Int?
    
    var hideAfterUnmatchIndex: Int?
    var hideAfterUnmatchIndex2: Int?
    
    var prevButtonIndex: Int?
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched { //проверяем, не нажал ли пользователь на уже угаданную пару карт
            if let matchingIndex = indexOfFaceUpCard, matchingIndex != index { //нам в функцию приходит индекс и мы проверяем, сейчас есть ли какая то перевёрнутая карта, если да, то не соответствует ли она той, что к нам пришла
                if cards[matchingIndex].identifier == cards[index].identifier { //если идентификаторы совпадают (т.е. смайлики одинаковые), то мэтч
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
        for _ in 1...numsOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
    }
}
