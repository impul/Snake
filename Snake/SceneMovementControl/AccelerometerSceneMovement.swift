//
//  AccelerometerSceneMovement.swift
//  Snake
//
//  Created on 09.05.18.
//

import Foundation
import CoreMotion

class AccelerometerSceneMovement:ControllerProtocol {
    
    weak var delegate:SceneMovementProtocol?
    private let cm = CMMotionManager()
    private var timer:Timer?
    
    init(delegate:SceneMovementProtocol, movementInterval:TimeInterval) {
        self.delegate = delegate
        cm.deviceMotionUpdateInterval = movementInterval/4
    }
    
    //MARK: - ControllerProtocol
    
    func beginUpdates() {
        cm.startDeviceMotionUpdates(to: OperationQueue.current ?? .main) { (deviceMotion, error) in
            guard error == nil, let attitude = deviceMotion?.attitude else {
                return
            }
            let roll = self.degrees(attitude.roll)
            let pitch = self.degrees(attitude.pitch)
            if abs(roll) > abs(pitch) {
                self.delegate?.move(to: roll > 0 ? .right : .left)
            } else {
                self.delegate?.move(to: pitch > 0 ? .down : .up)
            }
        }
    }
    
    func endUpdates() {
        cm.startAccelerometerUpdates()
    }
    
    func degrees(_ radians:Double) -> Double {
        return 180 / .pi * radians
    }
    
    var controllerAllowsRotation:Bool {
        return false
    }
    
}
