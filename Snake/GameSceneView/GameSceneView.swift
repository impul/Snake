//
//  GameScene.swift
//  Snake
//
//  Created on 08.05.18.
//  Copyright © 2018. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameComponents:String {
    case snake
    case barrier
    case fruit
}

class GameSceneView: SKScene,SKPhysicsContactDelegate {
    
    //MARK: Public
    
    public var gridSize:Int = 21
    
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
    
    public func drawNewSnakeHead(at point:Point,snake:Snake) {
        guard let snakeHead = blockObject.copy() as? SKShapeNode else { return }
        snakeHead.position = CGPoint(x: CGFloat(point.x) * self.size.width/CGFloat(gridSize), y: CGFloat(point.y) * self.size.width/CGFloat(gridSize))
        snakeHead.run(SKAction.sequence([SKAction.wait(forDuration: Double(snake.lenght) * snake.speed),
                                          SKAction.removeFromParent()]))
        snakeHead.fillColor = .green
        snakeHead.name = GameComponents.snake.rawValue
        snakeHead.physicsBody?.isDynamic = false
        addChild(snakeHead)
    }
    
    public func drawFruit(at point:Point) {
        guard let fruit = blockObject.copy() as? SKShapeNode else { return }
        fruit.position = CGPoint(x: CGFloat(point.x) * self.size.width/CGFloat(gridSize), y: CGFloat(point.y) * self.size.width/CGFloat(gridSize))
        fruit.fillColor = .red
        fruit.name = GameComponents.fruit.rawValue
        fruit.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),SKAction.fadeIn(withDuration: 0.1)])))
        addChild(fruit)
    }

    public func drawBarrier(at point:Point) {
        guard let barrier = blockObject.copy() as? SKShapeNode else { return }
        barrier.position = CGPoint(x: CGFloat(point.x) * self.size.width/CGFloat(gridSize), y: CGFloat(point.y) * self.size.width/CGFloat(gridSize))
        barrier.fillColor = .lightGray
        barrier.name = GameComponents.barrier.rawValue
        addChild(barrier)
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
            case .barrier,.snake:
                children.forEach({ (childe) in
                    childe.physicsBody?.affectedByGravity = true
                })
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
