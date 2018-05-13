//
//  GameControllerDelegate.swift
//  Snake
//
//  Created  on 13.05.18.
//  Copyright © 2018 DevChallenge. All rights reserved.
//

import Foundation

protocol GameControllerDelegate:class {
    func gameControllerDidFinishGame(_ controller:GameViewController,with score:Int,log: Data)
}
