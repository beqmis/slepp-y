//
//  HKSleepService.swift
//  slepp'y
//
//  Created by Яков Демиденко on 27.01.2026.
//


class HKSleepService: SleepServiceProtocol {
    func fetchSleepData() async -> (core: Double, deep: Double, rem: Double) {
        
        
        return (30, 25, 225)
    }
    
}

protocol SleepServiceProtocol {
    func fetchSleepData() async -> (core: Double, deep: Double, rem: Double)
}
