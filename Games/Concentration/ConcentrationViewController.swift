//
//  ViewController.swift
//  Concentration
//
//  Created by Anna Garcia on 5/15/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class ConcentrationViewController: VCLLoggingViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    override var vclLoggingName: String {
        return "Detail Game"
    }
    
    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var scoreCountLabel: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel!
    
    private var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flip Count: \(flipCount)"
        }
    }
    
    private var scoreCount = 0 { didSet { scoreCountLabel.text = "Score: \(scoreCount)"} }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else {
            print("card is not in cardButton array")
        }
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        // reset game
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        // reset theme choices
        emojiChoices = Theme().getRandomThemeIcons()
        // update view
        updateViewFromModel()
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViewFromModel(){
        if cardButtons != nil {
            flipCount = game.flipCount
            scoreCount = game.score
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                }
            }
            finishedLabel.textColor = game.allCardsHaveBeenMatched ? #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1) : #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
            finishedLabel.text = game.score >= 0 ? "Nice work! 👍" : "Phew, 🐻ly made it"
        }
    }
    
    var theme: [String]? {
        didSet {
            emojiChoices = theme ?? Theme().getRandomThemeIcons()
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    lazy var emojiChoices = Theme().getRandomThemeIcons()
    
    private var emoji = [ConcentrationCard: String]()
    
    private func emoji(for card: ConcentrationCard) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
}
