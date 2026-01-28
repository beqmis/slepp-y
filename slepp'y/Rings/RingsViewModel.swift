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

    private let sleepService:SleepServiceProtocol
    
    init(sleepService:SleepServiceProtocol) {
        self.sleepService = sleepService
        
        self.coreRing = RingTypeModel(percent: 0, backgroundColor: .cyan.opacity(0.2), foregroundColor: .cyan)
        self.deepRing = RingTypeModel(percent: 0, backgroundColor: .blue.opacity(0.2), foregroundColor: .blue)
        self.remRing = RingTypeModel(percent: 0, backgroundColor: .purple.opacity(0.2), foregroundColor: .purple)
    }
    
    @MainActor
    func updateRings() async {
        let data = await sleepService.fetchSleepData()
        
        withAnimation(.spring()) {
                    coreRing.percent = data.core
                    deepRing.percent = data.deep
                    remRing.percent = data.rem
                }
    }
    
    
    
}
