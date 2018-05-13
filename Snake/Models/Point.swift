//
//  Point.swift
//  Snake
//
//  Created  on 11.05.18.
//  Copyright © 2018 DevChallenge. All rights reserved.
//

import Foundation

struct Point:Codable,Equatable {
    var x:Int
    var y:Int
    
    mutating func updateWithDirection(_ direction:MovementDirection) {
        switch direction {
        case .up:
            y += 1
        case .down:
            y -= 1
        case .left:
            x -= 1
        case .right:
            x += 1
        }
    }
}
