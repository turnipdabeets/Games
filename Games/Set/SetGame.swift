//
//  Set.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import Foundation

struct SetGame
{
    private(set) var cardTotal = 81
    private(set) var cards = [Card]()
    private(set) var selectedCards = [Card]()
    
    init(){
        makeDeck()
        //        testDeck()
    }
    
    mutating private func testDeck(){
        for _ in 0..<21 {
            cards.append(Card(number: Card.Number.one, symbol: Card.Symbol.diamond, shading: Card.Shading.open, color:Card.Color.purple, state: nil))
        }
    }
    
    mutating private func makeDeck(){
        for number in Card.Number.all {
            for symbol in Card.Symbol.all {
                for shading in Card.Shading.all {
                    for color in Card.Color.all {
                        let card = Card(number: number, symbol: symbol, shading: shading, color: color, state: nil)
                        cards.append(card)
                    }
                }
            }
        }
    }
    
    mutating func drawCard() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        }else {
            return nil
        }
    }
    
    mutating func clearSelectedCards(){
        selectedCards.removeAll()
    }
    
    mutating func matchedCards() -> [Card]? {
        var matchedCards = [Card]()
        if selectedCards.count == 3 {
            //check if match
            let hasMatch = evaluateSet()
            if hasMatch {
                matchedCards = selectedCards
            }
        }
        return matchedCards.isEmpty ? nil : matchedCards
    }
    
    mutating func select(card: Card) {
        // remove from selected if previously selected
        if let index = selectedCards.index(of: card){
            selectedCards.remove(at: index)
            return
        }
        // save 3 total selected cards
        if selectedCards.count < 3 {
            selectedCards.append(card)
        }
    }
    
    func evaluateSet() -> Bool {
        // get three selected cards
        let cardOne = selectedCards[0]
        let cardTwo = selectedCards[1]
        let cardThree = selectedCards[2]
        // get set cases
        let allTheSameNumber = allTheSame(itemOne: cardOne.number.rawValue, itemTwo: cardTwo.number.rawValue, itemThree: cardThree.number.rawValue)
        let allDifferentNumber = allDifferent(itemOne: cardOne.number.rawValue, itemTwo: cardTwo.number.rawValue, itemThree: cardThree.number.rawValue)
        let allTheSameColor = allTheSame(itemOne: cardOne.color.rawValue, itemTwo: cardTwo.color.rawValue, itemThree: cardThree.color.rawValue)
        let allDifferentColor = allDifferent(itemOne: cardOne.color.rawValue, itemTwo: cardTwo.color.rawValue, itemThree: cardThree.color.rawValue)
        let allTheSameSymbol = allTheSame(itemOne: cardOne.symbol.rawValue, itemTwo: cardTwo.symbol.rawValue, itemThree: cardThree.symbol.rawValue)
        let allDifferentSymbol = allDifferent(itemOne: cardOne.symbol.rawValue, itemTwo: cardTwo.symbol.rawValue, itemThree: cardThree.symbol.rawValue)
        let allTheSameShading = allTheSame(itemOne: cardOne.shading.rawValue, itemTwo: cardTwo.shading.rawValue, itemThree: cardThree.shading.rawValue)
        let allDifferentShading = allDifferent(itemOne: cardOne.shading.rawValue, itemTwo: cardTwo.shading.rawValue, itemThree: cardThree.shading.rawValue)
        // check set cases
        if allTheSameNumber || allDifferentNumber {
            if allTheSameColor || allDifferentColor {
                if allTheSameSymbol || allDifferentSymbol {
                    if allTheSameShading || allDifferentShading {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func allTheSame(itemOne: Int, itemTwo: Int, itemThree:Int) -> Bool {
        return itemOne == itemTwo && itemTwo == itemThree
    }
    
    private func allDifferent(itemOne: Int, itemTwo: Int, itemThree:Int) -> Bool {
        return itemOne != itemTwo && itemTwo != itemThree && itemThree != itemOne
    }
    
}
