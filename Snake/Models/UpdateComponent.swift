//
//  UpdateComponent.swift
//  Snake
//
//  Created  on 13.05.18.
//  Copyright © 2018 DevChallenge. All rights reserved.
//

import Foundation

enum UpdateCompoment {
    
    case snake(GameViewUpdateModel)
    case barrier(GameViewUpdateModel)
    case fruit(GameViewUpdateModel)
    
    var model:GameViewUpdateModel {
        switch self {
        case .snake(let model):
            return model
        case .barrier(let model):
            return model
        case .fruit(let model):
            return model
        }
    }
}

extension UpdateCompoment: Codable {
    
    enum UpdateCompomentCodingError:Error {
        case decoding(String)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let update  = try? container.decode(GameViewUpdateModel.self, forKey: .snake) {
            self = .snake(update)
            return
        }
        if let update =  try? container.decode(GameViewUpdateModel.self, forKey: .barrier) {
            self = .barrier(update)
            return
        }
        if let update =  try? container.decode(GameViewUpdateModel.self, forKey: .fruit) {
            self = .fruit(update)
            return
        }
        throw UpdateCompomentCodingError.decoding("Opps \(dump(container))")
    }
    
    enum CodingKeys: CodingKey {
        case base
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
