//
//  GameViewController.swift
//  Snake
//
//  Created on 08.05.18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, SceneMovementProtocol {
    
    private var moventController:ControllerProtocol?
    private var scene:GameSceneView?
    private var snakeBody:[Point] = []
    private var fruits:[Point] = []
    private var barriers:[Point] = []
    private var snake:Snake = Snake()
    private var currectDirection:MovementDirection = .down
    
    private var timer:Timer?
    private var gridSize:Int = 11
    
    public var level:Int = 2
    public var gamePoint:Int = 0
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var startButton: UIButton!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupMovementController()
        setupBarriers()
    }
    
    func setupBarriers() {
        let barriersCount = level * gridSize/4
        for _ in 0..<barriersCount {
            let barrierPoint = randomPointAroundSnake()
            barriers.append(barrierPoint)
            scene?.drawBarrier(at: barrierPoint)
        }
    }
    
    func setupMovementController() {
        self.snake.headWidth = self.view.bounds.size.width/CGFloat(gridSize)
        moventController = AccelerometerSceneMovement(delegate: self, movementInterval:snake.speed)
        moventController?.beginUpdates()
    }
    
    private func setupScene() {
        guard let view = self.view as? SKView,
            let scene = SKScene(fileNamed: "GameSceneView") as? GameSceneView else { return }
        self.scene = scene
        self.scene?.gridSize = gridSize
        self.scene?.scaleMode = .aspectFill
        view.presentScene(scene)
    }
    
    //MARK: - Actions
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        sender.isHidden = true
        snakeBody = [Point(x:0,y:0)]
        timer = Timer.scheduledTimer(withTimeInterval: snake.speed, repeats: true, block:snakePrepareNextMovement)
        addNewFruit()
    }
    
    //MARK: - Movement
    
    func calculateSnakeNextPostion() {
        let spet = 1
        guard var newSnakePoint = snakeBody.first else { return }
        switch currectDirection {
        case .up:
            newSnakePoint.y += spet
        case .down:
            newSnakePoint.y -= spet
        case .left:
            newSnakePoint.x -= spet
        case .right:
            newSnakePoint.x += spet
        }
        if snakeBody.count > 2 && newSnakePoint == snakeBody[1]  { return }
        snakeBody.insert(newSnakePoint, at: 0)
       
        if snakeBody.count > snake.lenght && !isSnakeEatFruit() {
            snakeBody.removeLast()
        }
        checkGameOver()
        
    }
    
    //MARK: - Scene logic
    
    private lazy var snakePrepareNextMovement:(Timer)->() = { _ in
        self.calculateSnakeNextPostion()
        self.scene?.drawNewSnakeHead(at: self.snakeBody[0], snake: self.snake)
    }
    
    private func randomPointAroundSnake() -> Point {
        srandomdev()
        while true {
            let x = (Int(arc4random()) % gridSize) - abs(gridSize/2)
            let y = (Int(arc4random()) % gridSize) - abs(gridSize/2)
            let point = Point(x: x, y: y)
            if !snakeBody.contains(point) && !fruits.contains(point) && !barriers.contains(point) {
                return point
            }
        }
    }
    
    ///MARK: - Check fruit eat
    
    func isSnakeEatFruit() -> Bool {
        if fruits.contains(snakeBody[0]) {
            _ = fruits.drop { $0 == snakeBody[0] }
            addNewFruit()
            gamePoint += 1
            snake.lenght += 1
            return true
        }
        return false
    }
    
    func addNewFruit() {
        let fruitPoint = randomPointAroundSnake()
        fruits.append(fruitPoint)
        scene?.drawFruit(at: fruitPoint)
    }
    
    ///MAKR: - Check game over
    
    private func checkGameOver() {
        let isSnakeInGrid = abs(snakeBody[0].x) < (gridSize/2)+1 && abs(snakeBody[0].y) < (gridSize/2)+1
        let snakeTouchedBarrier = barriers.contains(snakeBody[0])
        
        if !isSnakeInGrid || snakeTouchedBarrier {
            gameOver()
        }
    }
    
    private func gameOver() {
        timer?.invalidate()
        startButton.isHidden = false
    }
    
    //MARK: - SceneMovementProtocol
    
    internal func move(to direction: MovementDirection) {
        guard currectDirection.asix != direction.asix else {
            return
        }
        currectDirection = direction
    }
    
    //MARK: - Overriding
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return (moventController?.controllerAllowsRotation ?? false) ? .allButUpsideDown : .portrait
        } else {
            return (moventController?.controllerAllowsRotation ?? false) ? .all : .portrait
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
