//
//  ThreadLocal.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 7/6/18.
//

import Foundation

internal class ThreadLocal<T> {
    private let dictionaryKey = "ThreadLocal.\(UUID().uuidString)"

    internal var value: T? {
        get {
            let dictionary = Thread.current.threadDictionary
            if let storedValue = dictionary[dictionaryKey] {
                guard let typedStoredValue = storedValue as? T else {
                    fatalError("Thread dictionary has been tampered with or UUID confict has occured. Thread dictionary contained different type than \(T.self) for key \(dictionaryKey).")
                }

                return typedStoredValue
            } else {
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                delete()
                return
            }

            #if os(macOS)
            let dictionary = Thread.current.threadDictionary
            dictionary[dictionaryKey] = newValue
            #else
            var dictionary = Thread.current.threadDictionary as [String: Any]
            dictionary[dictionaryKey] = newValue
            #endif
        }
    }

    internal init() {
    }

    internal func delete() {
        #if os(macOS)
        let dictionary = Thread.current.threadDictionary
        dictionary.removeObject(forKey: dictionaryKey)
        #else
        var dictionary = Thread.current.threadDictionary as [String: Any]
        dictionary.removeValue(forKey: dictionaryKey)
        #endif
    }
}
