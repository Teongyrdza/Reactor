//
//  File.swift
//  
//
//  Created by Ostap on 16.06.2021.
//

import XCTest
import Combine
@testable import Reactor

class PublishedTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPublished() {
        var container = DummyContainer(dummy: .init(name: "1"))
        var flag = false
        
        container.$dummy
            .sink {
                flag = true
            }
            .store(in: &cancellables)
        
        container.dummy = Dummy(name: "2")
        
        XCTAssert(flag, "Published does not send changes through it's publisher")
        
        flag = false
        
        container.dummy.name = "3"
        
        XCTAssert(flag, "Published does not send changes through it's publisher")
        
        container.registerDummy()
        
        container.objectWillChange
            .sink {
                flag = true
            }
            .store(in: &cancellables)
        
        container.dummy.name = "4"
        
        XCTAssert(flag, "Published does not send changes through registered publisher")
    }
    
    func testSubscriptions() {
        var container = DummyContainer()
        
        container.registerSubscriptions()
        
        let mirror = Mirror(reflecting: container)
        
        for child in mirror.children {
            if let published = child.value as? Registerable, let name = child.label {
                XCTAssert(published.registered, "Property \(name) is not registered")
            }
        }
    }
    
    struct DummyContainer: ObservableStruct {
        @Ignored var objectWillChange: PassthroughSubject<Void, Never> = .init()
        @StructPublished var dummy: Dummy = .init()
        
        mutating func registerDummy() {
            _dummy.register(on: self)
        }
    }
    
    struct Dummy: ObservableStruct, Hashable {
        @Ignored var objectWillChange: PassthroughSubject<Void, Never> = .init()
        
        var name = ""
    }
}
