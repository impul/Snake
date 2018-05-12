//
//  Grid.swift
//  Snake
//
//  Created on 11.05.18.
//  Copyright © 2018 DevChallenge. All rights reserved.
//

import Foundation
import SpriteKit

class Grid: SKSpriteNode {

    var gridSize:Int = 21

    convenience init?(gridSize:Int) {
        guard let texture = Grid.texture(gridSize:gridSize) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.gridSize = gridSize
    }

    class func texture(gridSize:Int) -> SKTexture? {
        let cellSize = UIScreen.main.bounds.width/CGFloat(gridSize)
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width+1)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        for i in 0...gridSize {
            let point = CGFloat(i)*cellSize + offset
            bezierPath.move(to: CGPoint(x: point, y: 0))
            bezierPath.addLine(to: CGPoint(x: point, y: size.height))
            bezierPath.move(to: CGPoint(x: 0, y: point))
            bezierPath.addLine(to: CGPoint(x: size.width, y: point))
        }
        SKColor.white.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return SKTexture(image: image!)
    }

}
