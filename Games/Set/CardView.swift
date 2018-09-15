//
//  CardView.swift
//  Set
//
//  Created by Anna Garcia on 6/15/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

protocol CardViewDelegate: class {
    func onButtonTap(card: Card)
}

class CardView: UIView {
    weak var delegate: CardViewDelegate?
    
    private var card: Card?
    
    private var number: Card.Number? {
        didSet{
            setNeedsDisplay()
        }
    }
    private(set) var symbol: Card.Symbol? {
        didSet{
            setNeedsDisplay()
        }
    }
    private var shading: Card.Shading? {
        didSet{
            setNeedsDisplay()
        }
    }
    private var color: Card.Color? {
        didSet{
            setNeedsDisplay()
        }
    }
    private var state: Card.State? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    init(frame: CGRect, card: Card) {
        super.init(frame: frame)
        self.card = card
        self.number = card.number
        self.symbol = card.symbol
        self.shading = card.shading
        self.color = card.color
        self.state = card.state
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(onButtonTap))
        self.addGestureRecognizer(tap)
    }
    
    @objc func onButtonTap(){
        if let card = card {
            delegate?.onButtonTap(card: card)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawCardCanvas()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // draw any number of card objects on card
        if let number = number, let symbol = symbol, let shading = shading, let color = color, let objectFrame = objectFrame {
            for num in 0..<number.rawValue {
                let object = CardObject(frame: objectFrame[num], symbol: symbol, shading: shading, color: color)
                addSubview(object)
            }
        }
    }
    
    private func drawCardCanvas(){
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
        #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).setStroke()
        if let state = state {
            switch state {
            case .matched:
                roundedRect.lineWidth = 3
                #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1).setStroke()
            case .misMatched:
                roundedRect.lineWidth = 3
                #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).setStroke()
            case .selected:
                roundedRect.lineWidth = 3
                #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).setStroke()
            }
        }
        roundedRect.fill()
        roundedRect.stroke()
    }
    
    /// get frames to init cardObject depending on number of cards
    private var objectFrame: [CGRect]? {
        var frames = [CGRect]()
        var space: CGFloat
        if let number = number {
            // get initial space
            switch number {
            case .one:
                space = initialSpaceForOneCard
            case .two:
                space = initialSpaceForTwoCards
            case .three:
                space = initialSpaceForThreeCard
            }
            for _ in 0..<number.rawValue {
                // TODO: figure out why this happens multiple times for one card
                let frame = CGRect(x: margin, y: space, width: widthOfObject, height: heightOfObject)
                frames.append(frame)
                space += oneRow + heightOfObject
            }
            return frames
        }
        return nil
    }
}

extension CardView {
    private var cornerRadius: CGFloat {
        return bounds.height * 0.03
    }
    private var oneRow: CGFloat {
        return bounds.height / 15
    }
    
    private var oneColumn: CGFloat {
        return bounds.width / 10
    }
    
    private var heightOfObject: CGFloat {
        return oneRow * 3
    }
    private var widthOfObject: CGFloat {
        return bounds.width - (oneColumn * 3 )
    }
    private var margin: CGFloat {
        return bounds.minX + (oneColumn * 1.5 )
    }
    private var initialSpaceForOneCard: CGFloat {
        return oneRow * 6
    }
    private var initialSpaceForTwoCards: CGFloat {
        return oneRow * 4
    }
    private var initialSpaceForThreeCard: CGFloat {
        return oneRow * 2
    }
}
