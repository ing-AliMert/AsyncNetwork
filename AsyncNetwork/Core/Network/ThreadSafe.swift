//
//  ThreadSafe.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import Foundation

// A thread-safe reference
final class ThreadSafe<T> {

    private let lock = DispatchQueue(label: "ThreadSafe.lock")
    private var _value: T?
    
    var value: T? {
        get { lock.sync { _value } }
        set { lock.sync { _value = newValue } }
    }
    
    init(_ value: T? = nil) {
        self._value = value
    }
}
