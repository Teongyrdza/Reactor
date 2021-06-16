//
//  Published.swift
//  
//
//  Created by Ostap on 16.06.2021.
//

import Combine
import Runtime

protocol Registerable {
    var registered: Bool { get }
    
    mutating func register(on observable: ObservableStruct)
}

@propertyWrapper
public struct StructPublished<Value: Equatable>: Equatable, Registerable {
    private let objectWillChange = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var subscribed = false
    public var registered = false
    
    public var wrappedValue: Value {
        willSet {
            objectWillChange.send()
        }
        didSet {
            if !subscribed {
                if let objectWillChange = (wrappedValue as? ObservableStruct)?.objectWillChange {
                    let sobjectWillChange = self.objectWillChange
                    
                    objectWillChange
                        .sink {
                            sobjectWillChange.send()
                        }
                        .store(in: &cancellables)
                }
                subscribed = true
            }
        }
    }
    
    public var projectedValue: PassthroughSubject<Void, Never> {
        objectWillChange
    }
    

    public mutating func register(on observable: ObservableStruct) {
        objectWillChange
            .pipe(to: observable.objectWillChange)
            .store(in: &cancellables)
        
        registered = true
    }
    
    public static func == (lhs: StructPublished<Value>, rhs: StructPublished<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        
        if let objectWillChange = (wrappedValue as? ObservableStruct)?.objectWillChange {
            let sobjectWillChange = self.objectWillChange
            
            objectWillChange
                .sink {
                    sobjectWillChange.send()
                }
                .store(in: &cancellables)
        }
        
        subscribed = true
    }
}

extension StructPublished: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

public extension ObservableStruct {
    /// A function to register all @StructPublished properties
    mutating func registerSubscriptions() {
        do {
            let mirror = Mirror(reflecting: self)
            let info = try typeInfo(of: Self.self)
            
            for child in mirror.children {
                if var published = child.value as? Registerable, let name = child.label {
                    published.register(on: self)
                    
                    let property = try info.property(named: name)
                    try property.set(value: published, on: &self)
                }
            }
        }
        catch {
            
        }
    }
}
