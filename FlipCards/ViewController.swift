//
//  ViewController.swift
//  FlipCards
//
//  Created by Blackwood Martain on 10/31/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var buttonCollections: [UIButton]!
    @IBOutlet private weak var flipsCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCards()
    }

    private lazy var game = ConcentrationGame(numsOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards : Int {
        return (buttonCollections.count + 1) / 2
    }
    private var emojiCollection = ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💗"]
    private var emojiDict = [Int:String]()
    private(set) var flips = 0 {
        didSet {
            flipsCount.text = "Flips: \(flips)"
        }
    }

    private func showCards() {
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

    private func emojiIdentifier(for card: Card) -> String {
        if emojiDict[card.identifier] == nil {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiCollection.count)))
            emojiDict[card.identifier] = emojiCollection.remove(at: randomIndex)
        }
        return emojiDict[card.identifier]!
    }

    private func hideBothCards(index: Int, matchingIndex: Int) {
        if game.cards[index].isMatched && game.cards[matchingIndex].isMatched {
            freezedDoubleFlip(index: index, matchingIndex: matchingIndex)
            game.hideAfterMatchIndex = nil
            game.hideAfterMatchIndex2 = nil
        } else {
            freezedDoubleFlip(index: index, matchingIndex: matchingIndex)
            game.hideAfterUnmatchIndex = nil
            game.hideAfterUnmatchIndex2 = nil
        }
    }
    
    private func freezedDoubleFlip(index: Int, matchingIndex: Int) {
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.flipCard(index: index, mode: false)
            self.flipCard(index: matchingIndex, mode: false)
            self.view.isUserInteractionEnabled = true
        }
    }

    private func flipCard(index: Int, mode: Bool) {
        if game.cards[index].isMatched {
            let str = NSAttributedString(string: "", attributes: [.font : UIFont.systemFont(ofSize: 50)])
            buttonCollections[index].setAttributedTitle(str, for: .normal)
        } else {
            switch mode {
                case true: //flip by background
                    if buttonCollections[index].backgroundColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
                        buttonCollections[index].backgroundColor = #colorLiteral(red: 0.999368608, green: 0.6251345277, blue: 0.05882481486, alpha: 1)
                        let str = NSAttributedString(string: "", attributes: [.font : UIFont.systemFont(ofSize: 50)])
                        buttonCollections[index].setAttributedTitle(str, for: .normal)
                    } else {
                        buttonCollections[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                        let str = NSAttributedString(string: emojiIdentifier(for: game.cards[index]), attributes: [.font : UIFont.systemFont(ofSize: 50)])
                        buttonCollections[index].setAttributedTitle(str, for: .normal)
                    }
                case false: //flip by title
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
    }

    private func updateView() {
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

    private func checker(index: Int?, matchingIndex: Int?) {
        if let _ = index, let _ = matchingIndex {
            hideBothCards(index: index!, matchingIndex: matchingIndex!)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVS = segue.destination as? ResultViewController else { return }
        destinationVS.flips = flips
    }

    @IBAction private func buttonsActions(_ sender: UIButton) {
        guard let buttonIndex = buttonCollections.firstIndex(of: sender) else { return }
        guard !game.cards[buttonIndex].isMatched else { return }
        flips += 1
        if let prevButton = game.prevButtonIndex {
            if prevButton == buttonIndex {
                flipCard(index: buttonIndex, mode: true)
                game.indexOfFaceUpCard = nil
                return
            }
        }
        game.chooseCard(at: buttonIndex)
        updateView()
        checker(index: game.hideAfterMatchIndex, matchingIndex: game.hideAfterMatchIndex2)
        checker(index: game.hideAfterUnmatchIndex, matchingIndex: game.hideAfterUnmatchIndex2)
        if game.gameOver {
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "resultSegue", sender: nil)
                self.view.isUserInteractionEnabled = true
            }
        }
        game.prevButtonIndex = buttonIndex
    }

    @IBAction private func unwindSegueToFirstVC(segue: UIStoryboardSegue) {
        flips = 0
        game.gameOver = false
        emojiCollection.removeAll()
        emojiCollection += ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💗"]
        emojiDict.removeAll()
        game = ConcentrationGame(numsOfPairsOfCards: (buttonCollections.count + 1) / 2)
        flipsCount.frame.origin = CGPoint(x: 29, y: 669)
        flipsCount.text = "Flips: \(flips)"
        showCards()
    }
}

