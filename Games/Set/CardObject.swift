//
//  Oval.swift
//  Set
//
//  Created by Anna Garcia on 6/15/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class CardObject: UIView {
    
    private var symbol: Card.Symbol?
    private var shading: Card.Shading?
    private var color: Card.Color?
    private var objectPath: UIBezierPath? {
        if let symbol = symbol {
            switch symbol {
            case .oval:
                return drawOval()
            case .diamond:
                return drawDiamond()
            case .squiggle:
                return drawSquiggle()
            }
        }
        return nil
    }
    
    init(frame: CGRect, symbol: Card.Symbol, shading: Card.Shading, color: Card.Color) {
        super.init(frame: frame)
        self.symbol = symbol
        self.shading = shading
        self.color = color
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let shape = objectPath, let shading = shading, let cardColor = color {
            // clip shape to add shading and color
            shape.addClip()
            // get color from Card color enum
            let color = getColor(for: cardColor)
            // shade shape with color
            switch shading {
            case .open:
                drawOutline(color: color, shape: shape)
            case .solid:
                fillWith(color: color, for: shape)
            case .striped:
                drawOutline(color: color, shape: shape)
                drawStripes()
            }
        }
    }
    
    // Draw Shapes
    private func drawOval() -> UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: 128)
    }
    private func drawDiamond() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
        path.addLine(to: CGPoint(x:bounds.maxX, y: bounds.height / 2))
        path.close()
        return path
    }
    private func drawSquiggle() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.maxX * 0.10, y: bounds.maxY))
        path.addCurve(to: CGPoint(x: bounds.minX, y: bounds.maxY * 0.80), controlPoint1: CGPoint(x: bounds.minX, y: bounds.maxY), controlPoint2: CGPoint(x: bounds.minX, y: bounds.maxY * 0.85))
        path.addCurve(to: CGPoint(x: bounds.maxX * 0.30, y: bounds.minY), controlPoint1: CGPoint(x: bounds.minX, y: bounds.midY), controlPoint2: CGPoint(x: bounds.maxX * 0.11, y: bounds.minY))
        path.addCurve(to: CGPoint(x: bounds.maxX * 0.65, y: bounds.maxY * 0.30), controlPoint1: CGPoint(x: bounds.midX, y: bounds.minY), controlPoint2: CGPoint(x: bounds.midX, y: bounds.midY))
        path.addCurve(to: CGPoint(x: bounds.maxX * 0.90, y: bounds.minY), controlPoint1: CGPoint(x: bounds.maxX * 0.70, y: bounds.midY * 0.5), controlPoint2: CGPoint(x: bounds.maxX * 0.85, y: bounds.minY))
        path.addCurve(to: CGPoint(x: bounds.maxX * 0.88, y: bounds.maxY * 0.88), controlPoint1: CGPoint(x: bounds.maxX * 1.10, y: bounds.minY), controlPoint2: CGPoint(x: bounds.maxX * 0.95, y: bounds.maxY * 0.80))
        path.addCurve(to: CGPoint(x: bounds.maxX * 0.60, y: bounds.maxY * 0.90), controlPoint1: CGPoint(x: bounds.maxX * 0.80, y: bounds.maxY), controlPoint2: CGPoint(x: bounds.maxX * 0.75, y: bounds.maxY))
        path.addCurve(to: CGPoint(x: bounds.maxX * 0.40, y: bounds.maxY * 0.75), controlPoint1: CGPoint(x: bounds.midX, y: bounds.maxY * 0.80), controlPoint2: CGPoint(x: bounds.midX, y: bounds.maxY * 0.80))
        path.addCurve(to: CGPoint(x: bounds.maxX * 0.10, y: bounds.maxY), controlPoint1: CGPoint(x: bounds.maxX * 0.30, y: bounds.maxY * 0.75), controlPoint2: CGPoint(x: bounds.maxX * 0.20, y: bounds.maxY))
        path.close()
        return path
    }
    
    // Draw Shading
    private func fillWith(color: UIColor, for shape: UIBezierPath){
        color.setFill()
        shape.fill()
    }
    private func drawStripes() {
        for x in stride(from: 0, to: bounds.width * 2, by: bounds.width * 0.06) {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: 0, y: x))
            path.stroke()
        }
    }
    private func drawOutline(color: UIColor, shape: UIBezierPath) {
        color.setStroke()
        shape.lineWidth = bounds.width / 60
        shape.stroke()
    }
    
    // Get Color
    private func getColor(for color:Card.Color) -> UIColor {
        switch color {
        case .teal:
            return #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        case .pink:
            return #colorLiteral(red: 1, green: 0.1607843137, blue: 0.4078431373, alpha: 1)
        }
    }
    
}
