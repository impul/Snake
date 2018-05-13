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
    
    private weak var moventController:ControllerProtocol?
    private var scene:GameSceneView?
    private var snakeBody:[Point] = []
    private var fruits:[Point] = []
    private var barriers:[Point] = []
    private var snake:Snake = Snake()
    private var currectDirection:MovementDirection = .down
    private var timer:Timer?
    
    var gridSize:Int = 11
    var level:Int = 2
    var gamePoint:Int = 0
    
    weak var delegate:GameControllerDelegate?
    
    var scenary = GameScenary()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupMovementController()
        setupBarriers()
        setupGame()
    }
    
    func setupGame() {
        snakeBody = [Point(x:0,y:0)]
        timer = Timer.scheduledTimer(withTimeInterval: snake.speed, repeats: true, block:snakePrepareNextMovement)
        addNewFruit()
    }
    
    func setupBarriers() {
        let barriersCount = level * gridSize/4
        for _ in 0..<barriersCount {
            let barrierPoint = randomPointAroundSnake()
            barriers.append(barrierPoint)
            let updateComponent = GameViewUpdateModel(point: barrierPoint, snake: snake)
            drawOnScene(.barrier(updateComponent))
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
    
    //MARK: - Draw
    
    func drawOnScene(_ component:UpdateCompoment) {
        scenary.comonents[Date().timeIntervalSince1970] = component
        scene?.draw(component:component)
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
    
    private lazy var snakePrepareNextMovement:(Timer)->() = { [weak self] _ in
        guard let `self` = self else { return }
        self.calculateSnakeNextPostion()
        let updateComponent = GameViewUpdateModel(point: self.snakeBody[0], snake: self.snake)
        self.drawOnScene(.snake(updateComponent))
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
        let updateComponent = GameViewUpdateModel(point: fruitPoint, snake: snake)
        drawOnScene(.fruit(updateComponent))
    }
    
    ///MAKR: - Check game over
    
    private func checkGameOver() {
        let isSnakeInGrid = abs(snakeBody[0].x) < (gridSize/2)+1 && abs(snakeBody[0].y) < (gridSize/2)+1
        let snakeEatBarrier = barriers.contains(snakeBody[0])
        let snakeEatHimself = snakeBody.filter{ $0 == snakeBody[0] }.count > 1
        
        if !isSnakeInGrid || snakeEatBarrier || snakeEatHimself {
            gameOver()
        }
    }
    
    private func gameOver() {
        timer?.invalidate()
        guard let data = try? JSONEncoder().encode(scenary) else { return }
        delegate?.gameControllerDidFinishGame(self, with:gamePoint, log: data)
        dismiss(animated: true)
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
