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

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = self.view as? SKView else {
            return
        }
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameSceneView") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
