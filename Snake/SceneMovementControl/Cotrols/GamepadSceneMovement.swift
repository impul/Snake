//
//  GamepadSceneMovement.swift
//  Snake
//
//  Created on 13.05.18.
//  Copyright © 2018 DevChallenge. All rights reserved.
//

import Foundation
import GameController

class GamepadSceneMovement: ControllerProtocol {
    
    private var timer:Timer?
    private var controller:GCController
    private var movementInterval:TimeInterval
    private weak var delegate:SceneMovementProtocol?
    
    required init(delegate: SceneMovementProtocol, movementInterval: TimeInterval) {
        self.delegate = delegate
        controller = GCController.controllers()[0] 
        self.movementInterval = movementInterval
    }
    
   /*Y
    / \
   X   B
    \ /
     A
    */
    
    func beginUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: movementInterval, repeats: true, block: { (tick) in
            if self.controller.gamepad?.buttonA.isPressed == true {
                self.delegate?.move(to: .down)
            } else if self.controller.gamepad?.buttonB.isPressed == true {
                 self.delegate?.move(to: .right)
            } else if self.controller.gamepad?.buttonX.isPressed == true {
                self.delegate?.move(to: .left)
            } else if self.controller.gamepad?.buttonY.isPressed == true {
                self.delegate?.move(to: .up)
            }
        })
    }
    
    func endUpdates() {
        timer?.invalidate()
    }
    
    var controllerAllowsRotation: Bool {
        return false
    }
    
    static var isAvailable:Bool {
        return GCController.controllers().count > 0
    }
}
