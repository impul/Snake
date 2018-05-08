//
//  GameScene.swift
//  Snake
//
//  Created on 08.05.18.
//  Copyright © 2018. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneView: SKScene, SceneMovementProtocol {
    
    private var snake: SKShapeNode = SKShapeNode()
    
    override func didMove(to view: SKView) {
        let w = (self.size.width + self.size.height) * 0.02
        snake = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.4)
        
        snake.strokeColor = .clear
        snake.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
        snake.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                          SKAction.fadeOut(withDuration: 0),
                                          SKAction.removeFromParent()]))
    }
    
    //MARK: - SceneMovementProtocol
    
    func move(to direction: MovementDirection) {
        
    }
    
}
