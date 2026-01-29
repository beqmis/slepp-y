//
//  RingsViewModel.swift
//  slepp'y
//
//  Created by Яков Демиденко on 26.01.2026.
//
import SwiftUI
import Combine

class RingsViewModel:ObservableObject
{
    @Published var coreRing:RingTypeModel
    @Published var deepRing:RingTypeModel
    @Published var remRing:RingTypeModel
    
    private let sleepService:SleepServiceProtocol & SleepAuthorizationProtocol
    
    init(sleepService:SleepServiceProtocol & SleepAuthorizationProtocol) {
        self.sleepService = sleepService
        
        self.coreRing = RingTypeModel(percent: 0, backgroundColor: .cyan.opacity(0.2), foregroundColor: .cyan)
        self.remRing = RingTypeModel(percent: 0, backgroundColor: .purple.opacity(0.2), foregroundColor: .purple)
        self.deepRing = RingTypeModel(percent: 0, backgroundColor: .blue.opacity(0.2), foregroundColor: .blue)
    }
    
    @MainActor
    func updateRings() async {
        
        let access = await sleepService.requestAuthorization()
        if access {
            let data = await sleepService.fetchSleepData()
            
            withAnimation(.spring()) {
                coreRing.percent = data.core * 1.81
                remRing.percent = data.rem * 4
                deepRing.percent = data.deep * 5
            }
        }
        
        
    }
    
}
