//
//  ControllerProtocol.swift
//  Snake
//
//  Created on 11.05.18.
//

import Foundation

protocol SceneControlDelegate:class {
    var controllerAllowsRotation:Bool { get }
    func beginUpdates()
    func endUpdates()
}
