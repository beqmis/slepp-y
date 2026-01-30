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
        
        self.coreRing = RingTypeModel(percent: 0, backgroundColor: .blue.opacity(0.2), foregroundColor: .blue)
        self.remRing = RingTypeModel(percent: 0, backgroundColor: .cyan.opacity(0.2), foregroundColor: .cyan)
        self.deepRing = RingTypeModel(percent: 0, backgroundColor: .indigo.opacity(0.2), foregroundColor: .indigo)
    }
    
    @MainActor
    func updateRings(selectedDate: Date) async {
        
        let access = await sleepService.requestAuthorization()
        if access {
            let data = await sleepService.fetchSleepData(endDate: selectedDate)
            
            withAnimation(.spring().speed(0.5)) {
                coreRing.percent = data.core * 1.81 //   (8h/percent of this type)
                remRing.percent = data.rem * 4
                deepRing.percent = data.deep * 5
            }
        }
        
        
    }
    
}
