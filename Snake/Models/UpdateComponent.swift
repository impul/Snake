//
//  UpdateComponent.swift
//  Snake
//
//  Created by Pavlo Boiko on 13.05.18.
//  Copyright © 2018 DevChallenge. All rights reserved.
//

import Foundation

enum UpdateCompoment:Codable {
    
    case snake(GameViewUpdateModel)
    case barrier(GameViewUpdateModel)
    case fruit(GameViewUpdateModel)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let update  = try container.decode(GameViewUpdateModel.self, forKey: .snake)
            self = .snake(update)
        }
        do {
            let update =  try container.decode(GameViewUpdateModel.self, forKey: .barrier)
            self = .barrier(update)
        }
        
        do {
            let update =  try container.decode(GameViewUpdateModel.self, forKey: .fruit)
            self = .fruit(update)
        }
    }
    
    enum CodingKeys: CodingKey {
        case snake
        case barrier
        case fruit
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .snake(let value):
            try container.encode(value, forKey: .snake)
        case .barrier(let value):
            try container.encode(value, forKey: .barrier)
        case .fruit(let value):
            try container.encode(value, forKey: .fruit)
        }
    }
    
}
