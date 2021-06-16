//
//  PipeTests.swift
//  
//
//  Created by Ostap on 16.06.2021.
//

import XCTest
import Combine
@testable import Reactor

class PipeTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test() {
        let publisher = PassthroughSubject<Void, Never>()
        
        var flag = false
        
        let objectWillChange = ObservableObjectPublisher()
        
        let c1 = objectWillChange
            .sink {
                flag = true
            }
        
        publisher
            .pipe(to: objectWillChange)
            .store(in: &cancellables)
        
        publisher.send()
        
        XCTAssert(flag, "Pipe does not connect PassthroughSubject to ObservableObjectPublisher")
        
        c1.cancel()
        
        flag = false
        
        let publisher2 = PassthroughSubject<Void, Never>()
        
        let c2 = publisher2
            .sink {
                flag = true
            }
        
        publisher
            .pipe(to: publisher2)
            .store(in: &cancellables)
        
        publisher.send()
        
        XCTAssert(flag, "Pipe does not connect PassthroughSubject to PassthroughSubject")
        
        c2.cancel()
    }
}
