//
//  ResultViewController.swift
//  FlipCards
//
//  Created by Blackwood Martain on 11/3/22.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var flips: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverLabel.text = "Game over!\n Total flips: \(flips ?? 0)"
    }
    
    @IBAction func tryAgainPressed(_ sender: UIButton) {
    }
    
}
