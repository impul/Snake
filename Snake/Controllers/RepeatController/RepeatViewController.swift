//
//  RepeatViewController.swift
//  Snake
//
//  Created  on 13.05.18.
//  Copyright © 2018 DevChallenge. All rights reserved.
//

import UIKit
import SpriteKit

class RepeatViewController: UIViewController {
    
    //MARK: Private
    
    private var scene:GameSceneView?
    private var fireTimes:[TimeInterval] = []
    private var scenary:[TimeInterval:UpdateCompoment] = [:]
    private var startOfCountdown:TimeInterval = 0
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    //MARK: - Actions
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: Setup
    
    func setupScenaryData(_ data:Data) {
        guard let scenary = try? JSONDecoder().decode(GameScenary.self, from: data) else {
            dismiss(animated: true)
            return
        }
        fireTimes = scenary.comonents.keys.sorted()
        self.scenary = scenary.comonents
        startOfCountdown = fireTimes[0]
    }
    
    private func setupScene() {
        guard let view = self.view as? SKView,
            let scene = SKScene(fileNamed: "GameSceneView") as? GameSceneView,
            let firstComponent = scenary.first else { return }
        self.scene = scene
        self.scene?.gridSize = firstComponent.value.model.snake.gridSize
        self.scene?.scaleMode = .aspectFill
        view.presentScene(scene)
        setupTimers()
    }
    
    //MARK: - Plaing
    
    func setupTimers() {
        fireTimes.forEach { (fireTime) in
            Timer.scheduledTimer(withTimeInterval: fireTime - startOfCountdown , repeats: false, block: { [weak self] _ in
                guard let `self` = self else { return }
                if let component = self.scenary[fireTime] {
                    self.scene?.draw(component: component)
                }
                if fireTime == self.fireTimes.last {
                    self.dismiss(animated: true)
                }
            })
        }
    }
    
}
