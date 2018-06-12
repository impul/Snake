//
//  GameScene.swift
//  Snake
//
//  Created on 08.05.18.
//  Copyright © 2018. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

fileprivate enum GameComponents:String {
    case snake
    case barrier
    case fruit
}

fileprivate struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let fruit     : UInt32 = 0b1
    static let barrier   : UInt32 = 0b10
    static let snake     : UInt32 = 0b11
}

class GameSceneView: SKScene,SKPhysicsContactDelegate {
    
    //MARK: Public
    
    public var gridSize:Int = 0
    
    //MARK: - Variables
    
    private var blockObject: SKShapeNode = SKShapeNode()
    private var viewFrame = CGRect.zero
    private var counter:SKLabelNode?
    
    //MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        viewFrame = view.frame
        drawArena()
        drawBlockTemplate()
        self.physicsWorld.contactDelegate = self
    }
    
    //MARK: - Drawing
    
    func draw(component:UpdateCompoment) {
        guard let newBlock = blockObject.copy() as? SKShapeNode else { return }
        switch component {
        case .snake(let update):
            newBlock.position = CGPoint(x: CGFloat(update.point.x) * self.size.width/CGFloat(gridSize), y: CGFloat(update.point.y) * self.size.width/CGFloat(gridSize))
            newBlock.run(SKAction.sequence([SKAction.wait(forDuration: Double(update.snake.lenght) * update.snake.speed),
                                             SKAction.removeFromParent()]))
            newBlock.fillColor = .green
            newBlock.name = GameComponents.snake.rawValue
            newBlock.physicsBody?.categoryBitMask = PhysicsCategory.snake
            newBlock.physicsBody?.contactTestBitMask = PhysicsCategory.fruit ^ PhysicsCategory.barrier
            newBlock.physicsBody?.collisionBitMask = PhysicsCategory.none
        case .fruit(let update):
            newBlock.position = CGPoint(x: CGFloat(update.point.x) * self.size.width/CGFloat(gridSize), y: CGFloat(update.point.y) * self.size.width/CGFloat(gridSize))
            newBlock.fillColor = .red
            newBlock.name = GameComponents.fruit.rawValue
            newBlock.physicsBody?.isDynamic = false
            newBlock.physicsBody?.categoryBitMask = PhysicsCategory.fruit
            newBlock.physicsBody?.contactTestBitMask = PhysicsCategory.snake
            newBlock.physicsBody?.collisionBitMask = PhysicsCategory.none
        case .barrier(let update):
            newBlock.position = CGPoint(x: CGFloat(update.point.x) * self.size.width/CGFloat(gridSize), y: CGFloat(update.point.y) * self.size.width/CGFloat(gridSize))
            newBlock.fillColor = .lightGray
            newBlock.name = GameComponents.barrier.rawValue
            newBlock.physicsBody?.isDynamic = false
            newBlock.physicsBody?.contactTestBitMask = PhysicsCategory.none
            newBlock.physicsBody?.collisionBitMask = PhysicsCategory.snake
            newBlock.physicsBody?.categoryBitMask = PhysicsCategory.barrier
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
        blockObject.physicsBody?.isDynamic = true
        
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
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                body.node?.removeFromParent()
            case .barrier:
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            default: return
            }
        }
    }
    
}
