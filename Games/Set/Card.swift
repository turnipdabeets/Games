//
//  Card.swift
//  Set
//
//  Created by Anna Garcia on 5/24/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import Foundation

/// hashable Card

struct Card: Hashable, CustomStringConvertible
{
    var description : String { return "|\(number) \(shading) & \(color) \(symbol) \(String(describing: state)) card |" }
    
    var number: Number
    var symbol: Symbol
    var shading: Shading
    var color: Color
    var state: State?
    
    enum Number : Int, CustomStringConvertible {
        var description: String {
            var title = ""
            switch self {
            case .one:
                title = "one"
            case .two:
                title = "two"
            case .three:
                title = "three"
            }
            return title
        }
        
        case one = 1
        case two = 2
        case three = 3
        
        static var all: [Number] {
            return [.one, .two, .three]
        }
    }
    
    enum Symbol: Int, CustomStringConvertible {
        var description: String {
            var title = ""
            switch self {
            case .diamond:
                title = "diamond"
            case .oval:
                title = "oval"
            case .squiggle:
                title = "squiggle"
            }
            return title
        }
        
        case diamond
        case oval
        case squiggle
        
        static var all: [Symbol] {
            return [.diamond, .oval, .squiggle]
        }
    }
    
    enum Shading: Int, CustomStringConvertible {
        var description: String {
            var title = ""
            switch self {
            case .solid:
                title = "solid"
            case .striped:
                title = "stripped"
            case .open:
                title = "open"
            }
            return title
        }
        
        case solid
        case striped
        case open
        
        static var all: [Shading] {
            return [.solid, .striped, .open]
        }
    }
    
    enum Color: Int, CustomStringConvertible {
        var description: String {
            var title = ""
            switch self {
            case .teal:
                title = "teal"
            case .pink:
                title = "pink"
            case .purple:
                title = "purple"
            }
            return title
        }
        
        case teal
        case pink
        case purple
        
        static var all: [Color] {
            return [.teal, .pink, .purple]
        }
    }
    
    enum State: Int, CustomStringConvertible {
        var description: String {
            var title = ""
            switch self {
            case .selected:
                title = "selected"
            case .matched:
                title = "matched"
            case .misMatched:
                title = "misMatched"
            }
            return title
        }
        case selected
        case matched
        case misMatched
        
        static var all: [State] {
            return [.selected, .matched, .misMatched]
        }
    }
    
    var hashValue: Int { return identifier  }
    private(set) var identifier: Int
    private static var identifierFactory = 0
    
    /// always return a unique number incrementing by 1
    private static func generateUUID() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(number: Number, symbol: Symbol, shading: Shading, color: Color, state: State?) {
        self.identifier = Card.generateUUID()
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
        self.state = state
    }
}
