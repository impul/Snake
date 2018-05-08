//
//  SceneMovementProtocol.swift
//  Snake
//
//  Created on 08.05.18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

enum MovementDirection {
    case top
    case buttom
    case left
    case right
}

protocol SceneMovementProtocol {
    func move(to direction:MovementDirection)
}
