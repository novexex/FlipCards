//
//  ViewController.swift
//  FlipCards
//
//  Created by Blackwood Martain on 10/31/22.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet var buttonCollections: [UIButton]!
    @IBOutlet weak var flipsCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tryAgainButton.isHidden = true
        showCards()
    }

    lazy var game = ConcentrationGame(numsOfPairsOfCards: (buttonCollections.count + 1) / 2)
    var emojiCollection = ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💗"]
    var emojiDict = [Int:String]()
    
    func showCards() {
        self.view.isUserInteractionEnabled = false
        flipsCount.isHidden = true
        for index in buttonCollections.indices {
            let str = NSAttributedString(string: emojiIdentifier(for: game.cards[index]), attributes: [.font : UIFont.systemFont(ofSize: 50)])
            buttonCollections[index].setAttributedTitle(str, for: .normal)
            buttonCollections[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.flipsCount.isHidden = false
            for index in self.buttonCollections.indices {
                let str = NSAttributedString(string: "", attributes: [.font : UIFont.systemFont(ofSize: 50)])
                self.buttonCollections[index].setAttributedTitle(str, for: .normal)
                self.buttonCollections[index].backgroundColor = #colorLiteral(red: 0.999368608, green: 0.6251345277, blue: 0.05882481486, alpha: 1)
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func emojiIdentifier(for card: Card) -> String {
        if emojiDict[card.identifier] == nil { //если в словаре нет нужного нам элемента
            let randomIndex = Int(arc4random_uniform(UInt32(emojiCollection.count))) //мы генерим рандомный индекс потолок у которого кол-во элементов в массиве
            emojiDict[card.identifier] = emojiCollection.remove(at: randomIndex) //вытаскиваем из массива рандомное эмодзи и засовываем в словарь
        }
        return emojiDict[card.identifier]!
    }

    var flips = 0 {
        didSet {
            flipsCount.text = "Flips: \(flips)"
        }
    }
    
    func gameOver() {
        for index in buttonCollections.indices {
            let str = NSAttributedString(string: "", attributes: [.font : UIFont.systemFont(ofSize: 50)])
            self.buttonCollections[index].setAttributedTitle(str, for: .normal)
        }
        flipsCount.frame.origin = CGPoint(x: 29, y: 350)
        flipsCount.text = "Game over!\n Total flips: \(flips)"
        tryAgainButton.isHidden = false
        tryAgainButton.frame.origin  = CGPoint(x: 140, y: 475)
    }
    
    func hideCards(index: Int, matchingIndex: Int) {
        if game.cards[index].isMatched && game.cards[matchingIndex].isMatched {
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.flipCard(index: index)
                self.flipCard(index: matchingIndex)
                self.view.isUserInteractionEnabled = true
            }
            game.hideAfterMatchIndex = nil
            game.hideAfterMatchIndex2 = nil
        } else {
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.flipCard(index: index)
                self.flipCard(index: matchingIndex)
                self.view.isUserInteractionEnabled = true
            }
            game.hideAfterUnmatchIndex = nil
            game.hideAfterUnmatchIndex2 = nil
        }
    }
    
    func flipCard(index: Int) {
        if game.cards[index].isMatched {
            let str = NSAttributedString(string: "", attributes: [.font : UIFont.systemFont(ofSize: 50)])
            buttonCollections[index].setAttributedTitle(str, for: .normal)
        } else {
            if buttonCollections[index].currentTitle == "" {
                let str = NSAttributedString(string: emojiIdentifier(for: game.cards[index]), attributes: [.font : UIFont.systemFont(ofSize: 50)])
                buttonCollections[index].setAttributedTitle(str, for: .normal)
            } else {
                let str = NSAttributedString(string: "", attributes: [.font : UIFont.systemFont(ofSize: 50)])
                self.buttonCollections[index].setAttributedTitle(str, for: .normal)
            }
            buttonCollections[index].backgroundColor = buttonCollections[index].backgroundColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) ? #colorLiteral(red: 0.999368608, green: 0.6251345277, blue: 0.05882481486, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    func updateView() {
        var allMatches = 0
        for index in buttonCollections.indices {
            if game.cards[index].isMatched {
                allMatches += 1
                if buttonCollections.count == allMatches {
                    game.gameOver = true
                }
            }
            if game.cards[index].isFaceUp {
                let str = NSAttributedString(string: emojiIdentifier(for: game.cards[index]), attributes: [.font : UIFont.systemFont(ofSize: 50)])
                buttonCollections[index].setAttributedTitle(str, for: .normal)
                buttonCollections[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            } else {
                let str = NSAttributedString(string: "", attributes: [.font : UIFont.systemFont(ofSize: 50)])
                self.buttonCollections[index].setAttributedTitle(str, for: .normal)
                buttonCollections[index].backgroundColor = game.cards[index].isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) :  #colorLiteral(red: 0.999368608, green: 0.6251345277, blue: 0.05882481486, alpha: 1)
            }
        }
    }

    @IBAction func buttonsActions(_ sender: UIButton) {
        guard !game.gameOver else { return }
        guard let buttonIndex = buttonCollections.firstIndex(of: sender) else { return }
        guard !game.cards[buttonIndex].isMatched else { return }
        game.chooseCard(at: buttonIndex)
        updateView()
        if let _ = game.hideAfterMatchIndex, let _ = game.hideAfterMatchIndex2 {
            hideCards(index: game.hideAfterMatchIndex!, matchingIndex: game.hideAfterMatchIndex2!)
        }
        if let _ = game.hideAfterUnmatchIndex, let _ = game.hideAfterUnmatchIndex2 {
            hideCards(index: game.hideAfterUnmatchIndex!, matchingIndex: game.hideAfterUnmatchIndex2!)
        }
        //if !game.gameOver && game.cards[buttonIndex].identifier != buttonCollections.firstIndex(of: sender) {
        if !game.gameOver && game.cards[buttonIndex].identifier != buttonCollections.firstIndex(of: sender) {
            flips += 1
        } else if game.gameOver {
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.gameOver()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func tryAgainPressed() {
        flips = 0
        game.gameOver = false
        emojiCollection.removeAll()
        emojiCollection += ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💗"]
        emojiDict.removeAll()
        
        game = ConcentrationGame(numsOfPairsOfCards: (buttonCollections.count + 1) / 2)
        flipsCount.frame.origin = CGPoint(x: 29, y: 669)
        flipsCount.text = "Flips: \(flips)"
        tryAgainButton.isHidden = true
        showCards()
    }
}

