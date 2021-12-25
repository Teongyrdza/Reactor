//
//  Ignored.swift
//  
//
//  Created by Ostap on 16.06.2021.
//

import Foundation

/// A wrapper for properites that are ignored during hashing and comparison
@propertyWrapper
public struct Ignored<Value>: Hashable, Encodable {
    public var wrappedValue: Value
    
    public static func == (lhs: Ignored, rhs: Ignored) -> Bool {
        true
    }
    
    public func hash(into hasher: inout Hasher) {
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}
