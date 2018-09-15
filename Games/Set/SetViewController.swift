//
//  ViewController.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class SetViewController: UIViewController, CardTableViewDelegate {
    func delegateCardTap(card: Card){
        selectCard(card: card)
    }
    
    @IBOutlet var mainView: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(deal))
            swipe.direction = [.down, .up]
            mainView.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
            mainView.addGestureRecognizer(rotate)
        }
    }
    @objc func shuffleCards(_ sender: UIRotationGestureRecognizer){
        if sender.state == .ended {
            for _ in 0..<visibleCards.count {
                visibleCards.sort(by: {_,_ in arc4random() > arc4random()})
            }
            resetTable()
        }
    }
    
    override func viewDidLoad() {
        grid.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // reset frame when device rotates
        grid.frame = CardTable.bounds
        // add cards to the card table
        CardTable.addSubview(grid)
    }
    
    // Game
    private var game = SetGame()
    private lazy var grid = CardTableView(frame: CardTable.bounds, cardsInPlay: visibleCards)
    
    // table to place all cards
    @IBOutlet weak var CardTable: UIView! {
        didSet {
            // set up buttons with 12 cards
            initalDeal()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        score = 0
        game = SetGame()
        visibleCards.removeAll()
        matched.removeAll()
        misMatched.removeAll()
        initalDeal()
        grid.cards = visibleCards
    }
    
    private func initalDeal(){
        for _ in 0..<12 {
            if let card = game.drawCard() {
                visibleCards.append(card)
            }
        }
    }
    
    // Cards
    private var visibleCards = [Card]()
    
    // Score
    @IBOutlet weak var scoreLabel: UILabel!
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // Deal
    @IBAction func deal(_ sender: UIButton) {
        handleDeal()
        if !matched.isEmpty && game.cards.isEmpty {
            removeMatchedCardsFromDeck()
        }
        resetTable()
    }
    private func handleDeal(){
        // have a match and cards available to deal
        if !matched.isEmpty && !game.cards.isEmpty {
            for card in matched {
                if let index = visibleCards.index(of: card){
                    // draw new card
                    if let newCard = game.drawCard() {
                        // set old visibleCard index to newCard
                        visibleCards[index] = newCard
                    } else {
                        // ran out of cards in the deck!
                    }
                }
            }
            matched.removeAll()
        } else {
            // deal three more
            if visibleCards.count < game.cardTotal {
                for _ in 0..<3 {
                    if let card = game.drawCard() {
                        // add more visible cards
                        visibleCards.append(card)
                    }
                }
            }
            // reset any matched or mismatched cards
            resetMisMatchedStyle()
            resetMatchedStyle()
        }
    }
    
    private func removeMatchedCardsFromDeck(){
        for card in matched {
            if let index = visibleCards.index(of: card){
                visibleCards.remove(at: index)
            }
        }
    }
    
    private func resetMatchedStyle(){
        for card in matched {
            if let idx = visibleCards.index(of: card){
                visibleCards[idx].state = nil
            }
        }
        matched.removeAll()
    }
    
    private func resetMisMatchedStyle(){
        for card in misMatched {
            if let idx = visibleCards.index(of: card){
                visibleCards[idx].state = nil
            }
        }
        misMatched.removeAll()
    }
    
    private func resetTable(){
        grid.removeFromSuperview()
        grid = CardTableView(frame: CardTable.bounds, cardsInPlay: visibleCards)
        grid.delegate = self
        CardTable.addSubview(grid)
    }
    
    // Select Card
    private var misMatched = [Card]()
    private var matched = [Card]()
    
    func selectCard(card: Card) {
        // must deal more cards if we have a match first
        if !matched.isEmpty && !game.cards.isEmpty {
            return
        }
        
        // deal no longer possible
        if !matched.isEmpty && game.cards.isEmpty {
            removeMatchedCardsFromDeck()
        }
        
        // reset any mismatched card styles
        if !misMatched.isEmpty {
            resetMisMatchedStyle()
        }
        
        // select or deselect card
        game.select(card: card)
        
        // check for match
        evaulate(card: card)
        // resetTable
        resetTable()
    }
    
    private func evaulate(card: Card){
        if let matchedCards = game.matchedCards() {
            matched = matchedCards
            game.clearSelectedCards()
            score += 3
            // set visible cards to matched
            for card in matchedCards {
                if let idx = visibleCards.index(of: card){
                    visibleCards[idx].state = .matched
                }
            }
        }else {
            if game.selectedCards.count == 3 {
                misMatched = game.selectedCards
                game.clearSelectedCards()
                score -= 5
                for card in misMatched {
                    if let idx = visibleCards.index(of: card){
                        visibleCards[idx].state = .misMatched
                    }
                }
            }else {
                // toggle selected
                if let idx = visibleCards.index(of: card){
                    if visibleCards[idx].state == .selected {
                        visibleCards[idx].state = nil
                    }else {
                        visibleCards[idx].state = .selected
                    }
                }
            }
        }
    }
}
