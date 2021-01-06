//
//  String+ramdom.swift
//  RandomContacts
//
//  Created by Jinwoo Kim on 1/6/21.
//

import Foundation

public extension String {
    static func ramdomInt(digits: Int) -> String {
        return (0..<digits).reduce("") { (value, _) in
            return value + "\(Int.random(in: 0...9))"
        }
    }
    
    static func randomHangul(digits: Int) -> String {
        return (0..<digits).reduce("") { (value, _) in
            return value + "\(Character.randomHangul())"
        }
    }
    
    static func randomEnglish(digits: Int) -> String {
        return (0..<digits).reduce("") { (value, _) in
            return value + "\(Character.randomEnglish())"
        }
    }
}
