//
//  Card.swift
//  Concentration
//
//  Created by bkmsx on 2/11/18.
//  Copyright © 2018 bkmsx. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatch = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int{
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    
}
