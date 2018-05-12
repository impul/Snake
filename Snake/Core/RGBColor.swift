//
//  RGB+UIColor.swift
//  Snake
//
//  Created by Pavlo Boiko on 11.05.18.
//  Copyright © 2018 DevChallenge. All rights reserved.
//

import UIKit.UIColor

public func RGB(_ r:Int,_ g:Int,_ b:Int) -> UIColor {
    return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
}
