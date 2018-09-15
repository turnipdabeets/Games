//
//  CardTableView.swift
//  Set
//
//  Created by Anna Garcia on 6/16/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

protocol CardTableViewDelegate: class {
    func delegateCardTap(card: Card)
}

class CardTableView: UIView, CardViewDelegate {
    weak var delegate: CardTableViewDelegate?
    func onButtonTap(card: Card) {
        delegateCardTap(card: card)
    }
    func delegateCardTap(card: Card){
        delegate?.delegateCardTap(card: card)
    }
    
    var cards = [Card]() {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    init(frame: CGRect, cardsInPlay: [Card]) {
        super.init(frame: frame)
        self.cards = cardsInPlay
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func draw(_ rect: CGRect) {
    //        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 128)
    //        #colorLiteral(red: 0.9472620869, green: 0.1898318151, blue: 0.172613248, alpha: 1).setFill()
    //        path.fill()
    //    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // remove any cards before drawing them incase of screen rotation
        for cardView in self.subviews {
            cardView.removeFromSuperview()
        }
        let dimensions = getDimensionsWith(aspectRatio: Const.aspectRatio, space: Const.space)
        let cardWidth = dimensions.width + Const.space
        let cardHeight = dimensions.height + Const.space
        // calculate margin from excess space
        var cardsPerRow = bounds.width / dimensions.width
        var cardsPerCols = bounds.height / dimensions.height
        cardsPerRow.round(.down)
        cardsPerCols.round(.down)
        
        let marginWidth = (bounds.width - cardWidth * cardsPerRow) / 2
        let marginHeight = (bounds.height - cardHeight * cardsPerCols) / 2
        let margin = marginWidth > marginHeight ? marginWidth : marginHeight
        var x = bounds.minX + margin
        var y = bounds.minY
        
        for card in cards {
            let playingCard = CardView(frame: CGRect(x: x, y: y, width: dimensions.width, height: dimensions.height), card: card)
            addSubview(playingCard)
            playingCard.delegate = self
            x += cardWidth
            
            // start a new row if card after next is out of bounds
            if(x + cardWidth >= bounds.width){
                y += cardHeight
                x = margin
            }
        }
    }
    
    func getDimensionsWith(aspectRatio: CGFloat, space: CGFloat) -> (width: CGFloat, height: CGFloat){
        var cols = CGFloat(), rows = CGFloat(), ch = CGFloat(), cw = CGFloat()
        
        func row(iterator numRows: CGFloat){
            rows = numRows
            cols = CGFloat(ceil(Double(cards.count) / Double(rows)))
            
            ch = (bounds.height - (numRows - 1) * space ) / rows
            cw = ch * aspectRatio
            
            if (cols * cw + (cols - 1) * space > bounds.width) {
                row(iterator: rows + 1)
            }
        }
        row(iterator: CGFloat(1))
        let size1 = (width: cw, height: ch)
        func col(iterator numCols: CGFloat){
            cols = numCols
            rows = CGFloat(ceil(Double(cards.count) / Double(cols)))
            
            ch = (bounds.height - (numCols - 1) * space ) / cols
            cw = ch / aspectRatio
            
            if(rows * ch + (rows - 1) * space > bounds.height){
                col(iterator: cols + 1)
            }
        }
        col(iterator: CGFloat(1))
        let size2 = (width: cw, height: ch)
        
        return (width: min(size1.width, size2.width), height: min(size1.height, size2.height))
    }
    
}

extension CardTableView {
    private struct Const {
        static let aspectRatio: CGFloat = 0.625
        static let space: CGFloat = 0.8
    }
}
