//
//  String+ramdomInt.swift
//  RandomContacts
//
//  Created by Jinwoo Kim on 1/6/21.
//

import Foundation

public extension String {
    static func ramdomInt(digits: Int) -> String {
        var value: String = ""
        
        (0..<digits).forEach { _ in
            value += "\(Int.random(in: 0...9))"
        }
        
        return value
    }
}
