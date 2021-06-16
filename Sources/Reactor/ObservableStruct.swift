//
//  ObservableStrcut.swift
//  
//
//  Created by Ostap on 16.06.2021.
//

import Combine

protocol ObservableStruct {
    var objectWillChange: PassthroughSubject<Void, Never> { get }
}
