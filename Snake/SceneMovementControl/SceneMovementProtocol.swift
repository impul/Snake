//
//  SceneMovementProtocol.swift
//  Snake
//
//  Created on 08.05.18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

enum MovementDirection {
    case up
    case down
    case left
    case right
    
    var asix:Asix {
        switch self {
        case .up,.down:
            return .y
        case .left,.right:
            return .x
        }
    }
    
    enum Asix {
        case x
        case y
    }
    
}

protocol SceneMovementProtocol:class {
    func move(to direction:MovementDirection)
}
