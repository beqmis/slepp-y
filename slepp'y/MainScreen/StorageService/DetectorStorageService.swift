//
//  DetectorStorageService.swift
//  slepp'y
//
//  Created by Яков Демиденко on 11.02.2026.
//

import Foundation

protocol DetectorStorageServiceProtocol {
    func save<T>(_ value: T, for date: Date, key: String)
    func fetch<T>(for date: Date, key: String) -> T?
}


class DetectorStorageService: DetectorStorageServiceProtocol {
    
    private let defaults = UserDefaults.standard
    
    private static let keyFormatter:DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private func createKey(_ date: Date, _ key: String) -> String {

        let formatter = Self.keyFormatter
        
        return "\(formatter.string(from: date))_\(key)"
    }
    
    func save<T>(_ value: T, for date: Date, key: String) {
        defaults.set(value, forKey: createKey(date, key))
    }
    
    func fetch<T>(for date: Date, key: String) -> T? {
        return defaults.object(forKey: createKey(date, key)) as? T
    }
    
    
}
