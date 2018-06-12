//
//  GameViewController.swift
//  Snake
//
//  Created on 08.05.18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SceneMovementProtocol {
    
    //MARK: - Private
    
    private var moventControl:ControllerProtocol?
    private var scene:GameSceneView?
    private var snakeBody:[Point] = []
    private var fruits:[Point] = []
    private var barriers:[Point] = []
    private var snake:Snake = Snake()
    private var currectDirection:MovementDirection = .down
    
    //MARK: - Public
    
    var control:MovementControls = .accelerometer
    var gridSize:Int = 11
    var level:Int = 2
    var gamePoint:Int = 0
    var scenary = GameScenary()
    weak var controllerDelegate:GameControllerDelegate?
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupMovementController()
        setupBarriers()
        setupGame()
    }
    
    //MARK: - Setup
    
    func setupGame() {
        snakeBody = [Point(x:0,y:0)]
        addNewFruit()
    }
    
    func setupBarriers() {
        let barriersCount = level * gridSize/4
        for _ in 0..<barriersCount {
            let barrierPoint = randomPointAroundSnake(withInset: 2)
            barriers.append(barrierPoint)
            let updateComponent = GameViewUpdateModel(point: barrierPoint, snake: snake)
            drawOnScene(.barrier(updateComponent))
        }
    }
    
    func setupMovementController() {
        self.snake.gridSize = gridSize
        self.snake.headWidth = self.view.bounds.size.width/CGFloat(gridSize)
        switch control {
        case .accelerometer:
            moventControl = AccelerometerSceneMovement(delegate: self, movementInterval: snake.speed)
        case .gamepad:
            moventControl = GamepadSceneMovement(delegate: self, movementInterval:snake.speed)
        }
        
        moventControl?.beginUpdates()
    }
    
    private func setupScene() {
        guard let view = self.view as? SKView,
            let scene = SKScene(fileNamed: "GameSceneView") as? GameSceneView else { return }
        self.scene = scene
        self.scene?.gridSize = gridSize
        self.scene?.scaleMode = .aspectFill
        view.presentScene(scene)
    }
    
    //MARK: - Action
    
    @IBAction func pauseAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? moventControl?.endUpdates() : moventControl?.beginUpdates()
    }
    
    //MARK: - Draw
    
    func drawOnScene(_ component:UpdateCompoment) {
        scenary.comonents[Date().timeIntervalSince1970] = component
        scene?.draw(component:component)
    }
    
    //MARK: - Scene logic
    
    private func randomPointAroundSnake(withInset:Int = 0) -> Point {
        srandomdev()
        let size = gridSize - withInset
        while true {
            let x = (Int(arc4random()) % size) - abs(size/2)
            let y = (Int(arc4random()) % size) - abs(size/2)
            let point = Point(x: x, y: y)
            if !snakeBody.contains(point) && !fruits.contains(point) && !barriers.contains(point) {
                return point
            }
        }
    }
    
    //MARK: - Check fruit eat
    
    func isSnakeEatFruit() -> Bool {
        if fruits.contains(snakeBody[0]) {
            guard let index = fruits.index(of: snakeBody[0]) else { return false }
            fruits.remove(at: index)
            addNewFruit()
            gamePoint += 1
            snake.lenght += 1
            score.text = "\(gamePoint)"
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
            print("Snake out of grid \(!isSnakeInGrid)")
            print("Snake eat barrier \(snakeEatBarrier)")
            print("Snake eat himself \(snakeEatHimself)")
            print("Snake: \(snakeBody)")
            print("Barriers: \(barriers)")
            print("Fruits: \(fruits)")
            gameOver()
        }
    }
    
    private func gameOver() {
        moventControl?.endUpdates()
        guard let data = try? JSONEncoder().encode(scenary) else { return }
        controllerDelegate?.gameControllerDidFinishGame(self, with:gamePoint, log: data)
        dismiss(animated: true)
    }
    
    //MARK: - SceneMovementProtocol
    
    internal func move(to direction: MovementDirection) {
        guard var newSnakePoint = snakeBody.first else { return }
        if currectDirection.asix != direction.asix {
            currectDirection = direction
        }
        newSnakePoint.updateWithDirection(currectDirection)
        snakeBody.insert(newSnakePoint, at: 0)
        
        if snakeBody.count > snake.lenght && !isSnakeEatFruit() {
            snakeBody.removeLast()
        }
        checkGameOver()
        let updateComponent = GameViewUpdateModel(point: self.snakeBody[0], snake: self.snake)
        self.drawOnScene(.snake(updateComponent))
    }
    
    //MARK: - Overriding
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return (moventControl?.controllerAllowsRotation ?? false) ? .allButUpsideDown : .portrait
        } else {
            return (moventControl?.controllerAllowsRotation ?? false) ? .all : .portrait
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
