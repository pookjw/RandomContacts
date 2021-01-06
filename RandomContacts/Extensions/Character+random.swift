//
//  Character+random.swift
//  RandomContacts
//
//  Created by Jinwoo Kim on 1/6/21.
//

import Foundation

public extension Character {
    static func randomHangul() -> Character {
        let startHexIndex: String = "AC00"
        let endHexIndex: String = "D7AF"
        guard let startDecIndex = Int(startHexIndex, radix: 16) else { return "엥" }
        guard let endDecIndex = Int(endHexIndex, radix: 16) else { return "엥" }
        
        let randomIndex = Int.random(in: startDecIndex...endDecIndex)
        guard let unicode = UnicodeScalar(randomIndex) else { return "엥" }
        
        return Character(unicode)
    }
    
    static func randomEnglish() -> Character {
        let startHexIndex: String = "0061"
        let endHexIndex: String = "007A"
        guard let startDecIndex = Int(startHexIndex, radix: 16) else { return "엥" }
        guard let endDecIndex = Int(endHexIndex, radix: 16) else { return "엥" }
        
        let randomIndex = Int.random(in: startDecIndex...endDecIndex)
        guard let unicode = UnicodeScalar(randomIndex) else { return "엥" }
        
        return Character(unicode)
    }
}
