//
//  Specifier.swift
//  
//
//  Created by Ostap on 16.06.2021.
//

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: CVarArg, specifier: String) {
        appendInterpolation(String(format: specifier, value))
    }
}
