//
//  PublishedBenchmark.swift
//  
//
//  Created by Ostap on 16.06.2021.
//

import Foundation
import Reactor
import Combine

private struct Dummy: ObservableStruct {
    @Ignored var objectWillChange: PassthroughSubject<Void, Never> = .init()
    
    @StructPublished var p0 = ""
    @StructPublished var p1 = ""
    @StructPublished var p2 = ""
    @StructPublished var p3 = ""
    @StructPublished var p4 = ""
    @StructPublished var p5 = ""
    
    mutating func register() {
        _p0.register(on: self)
        _p1.register(on: self)
        _p2.register(on: self)
        _p3.register(on: self)
        _p4.register(on: self)
        _p5.register(on: self)
    }
}

class PublishedBenchmark: Benchmark {
    func testManualRegistration() {
        var dummy = Dummy()

        let start = Date()
        dummy.register()
        let end = Date()
        
        let elapsed = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
        
        print("Manual registration took \(elapsed, specifier: "%.6f") seconds")
    }
    
    func testReflectionRegistration() {
        var dummy = Dummy()

        let start = Date()
        dummy.registerSubscriptions()
        let end = Date()
        
        let elapsed = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
        
        print("Registration using reflection took \(elapsed, specifier: "%.6f") seconds")
    }
    
    func run() {
        testManualRegistration()
        testReflectionRegistration()
    }
}
