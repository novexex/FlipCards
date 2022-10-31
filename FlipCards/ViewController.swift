//
//  ViewController.swift
//  FlipCards
//
//  Created by Blackwood Martain on 10/31/22.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var buttonCollections: [UIButton]!
    @IBOutlet weak var flipsCount: UILabel!
    
    lazy var game = ConcentrationGame(numsOfPairsOfCards: buttonCollections.count / 2)
    
    var flips = 0 {
        didSet {
            flipsCount.text = "Flips: \(flips)"
        }
    }
    
    func flipButton(emoji: String, button: UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.999368608, green: 0.6251345277, blue: 0.05882481486, alpha: 1)
        } else {
            button.setTitle(emoji, for: .normal)
            button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }

    @IBAction func buttonsActions(_ sender: UIButton) {
        flip
    }
    
}

