//
//  ControllerProtocol.swift
//  Snake
//
//  Created on 11.05.18.
//

import Foundation

protocol ControllerProtocol:class {
    var controllerAllowsRotation:Bool { get }
    func beginUpdates()
    func endUpdates()
}
