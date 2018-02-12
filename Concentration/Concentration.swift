//
//  Concentration.swift
//  Concentration
//
//  Created by bkmsx on 2/11/18.
//  Copyright © 2018 bkmsx. All rights reserved.
//

import Foundation

class Contrentration {
    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatch {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[index].identifier == cards[matchIndex].identifier {
                    cards[index].isMatch = true
                    cards[matchIndex].isMatch = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                indexOfOneAndOnlyFaceUpCard = index
                cards[index].isFaceUp = true
            }
        }
    }
    
    init(numberOfPairOfCard: Int) {
        for _ in 0..<numberOfPairOfCard {
            let card = Card()
            cards += [card, card]
        }
        shuffleCards()
    }
    
    func  shuffleCards() {
        var tempCards = cards
        for index in cards.indices {
            let randomNumber = Int(arc4random_uniform(UInt32(tempCards.count)))
            cards[index] = tempCards.remove(at: randomNumber)
        }
    }
    
    func reset() {
        indexOfOneAndOnlyFaceUpCard = nil
        for index in cards.indices {
            cards[index].isMatch = false
            cards[index].isFaceUp = false
        }
        shuffleCards()
    }
}
