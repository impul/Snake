//
//  GameScene.swift
//  Snake
//
//  Created on 08.05.18.
//  Copyright © 2018. All rights reserved.
//

import SpriteKit
import GameplayKit

fileprivate enum GameComponents:String {
    case snake
    case barrier
    case fruit
}

class GameSceneView: SKScene,SKPhysicsContactDelegate {
    
    //MARK: Public
    
    public var gridSize:Int = 0
    
    //MARK: - Variables
    
    private var blockObject: SKShapeNode = SKShapeNode()
    private var viewFrame = CGRect.zero
    
    //MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        viewFrame = view.frame
        drawArena()
        drawBlockTemplate()
        self.physicsWorld.contactDelegate = self
    }
    
    func draw(component:UpdateCompoment) {
        guard let newBlock = blockObject.copy() as? SKShapeNode else { return }
        switch component {
        case .snake(let update):
            newBlock.position = CGPoint(x: CGFloat(update.point.x) * self.size.width/CGFloat(gridSize), y: CGFloat(update.point.y) * self.size.width/CGFloat(gridSize))
            newBlock.run(SKAction.sequence([SKAction.wait(forDuration: Double(update.snake.lenght) * update.snake.speed),
                                             SKAction.removeFromParent()]))
            newBlock.fillColor = .green
            newBlock.name = GameComponents.snake.rawValue
            newBlock.physicsBody?.isDynamic = false
        case .fruit(let update):
            newBlock.position = CGPoint(x: CGFloat(update.point.x) * self.size.width/CGFloat(gridSize), y: CGFloat(update.point.y) * self.size.width/CGFloat(gridSize))
            newBlock.fillColor = .red
            newBlock.name = GameComponents.fruit.rawValue
            newBlock.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),SKAction.fadeIn(withDuration: 0.1)])))
        case .barrier(let update):
            newBlock.position = CGPoint(x: CGFloat(update.point.x) * self.size.width/CGFloat(gridSize), y: CGFloat(update.point.y) * self.size.width/CGFloat(gridSize))
            newBlock.fillColor = .lightGray
            newBlock.name = GameComponents.barrier.rawValue
        }
        addChild(newBlock)
    }
    
    private func drawBlockTemplate() {
        let w = self.size.width/CGFloat(gridSize)
        blockObject = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: 0)
        blockObject.strokeColor = .clear
        blockObject.alpha = 1
        let blockSize = blockObject.frame.size
        blockObject.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: blockSize.width - 1, height: blockSize.height - 1))
        blockObject.physicsBody?.affectedByGravity = false
        blockObject.physicsBody?.contactTestBitMask = blockObject.physicsBody?.collisionBitMask ?? 0
    }
    
    private func drawArena() {
        if let grid = Grid(gridSize: gridSize) {
            grid.position = CGPoint(x: 0, y:0)
            grid.size = CGSize(width: frame.width, height: frame.width)
            grid.alpha = 0.4
            addChild(grid)
        }
    }

    //MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        [contact.bodyA,contact.bodyB].forEach { (body) in
            guard let node = body.node?.name ,
                  let component = GameComponents(rawValue:node) else { return }
            switch component {
            case .fruit:
                body.node!.run(SKAction.removeFromParent())
            case .barrier:
                children.forEach({ (childe) in
                    childe.physicsBody?.affectedByGravity = true
                })
            default: return
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
