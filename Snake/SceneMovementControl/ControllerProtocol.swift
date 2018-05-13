//
//  ControllerProtocol.swift
//  Snake
//
//  Created on 11.05.18.
//

import Foundation

enum MovementControls:Int {
    case accelerometer = 0
    case gamepad
}

protocol ControllerProtocol:class {
    
    static var isAvailable:Bool { get }
    init(delegate:SceneMovementProtocol, movementInterval:TimeInterval)
    var controllerAllowsRotation:Bool { get }
    func beginUpdates()
    func endUpdates()
}
