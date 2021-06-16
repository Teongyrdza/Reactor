//
//  Pipe.swift
//  
//
//  Created by Ostap on 16.06.2021.
//

import Combine

public extension Publisher where Failure == Never {
    func pipe(to other: PassthroughSubject<Void, Never>) -> AnyCancellable {
        self
            .sink { _ in
                other.send()
            }
    }
    
    func pipe(to other: ObservableObjectPublisher) -> AnyCancellable {
        self
            .sink { _ in
                other.send()
            }
    }
}

