//
//  RingsViewModel.swift
//  slepp'y
//
//  Created by Яков Демиденко on 26.01.2026.
//
import SwiftUI
import Combine

@MainActor
class RingsViewModel:ObservableObject
{
    @Published var coreRing:RingTypeModel
    @Published var deepRing:RingTypeModel
    @Published var remRing:RingTypeModel
    
    @Published var inBedHours:String = "-"
    @Published var inBedMin:String = "-"
    
    private let sleepService:SleepServiceProtocol & SleepAuthorizationProtocol & SleepDurationProtocol
    
    init(sleepService:SleepServiceProtocol & SleepAuthorizationProtocol & SleepDurationProtocol) {
        self.sleepService = sleepService
        
        self.coreRing = RingTypeModel(percent: 0, backgroundColor: .blue.opacity(0.2), foregroundColor: .blue)
        self.remRing = RingTypeModel(percent: 0, backgroundColor: .cyan.opacity(0.2), foregroundColor: .cyan)
        self.deepRing = RingTypeModel(percent: 0, backgroundColor: .indigo.opacity(0.2), foregroundColor: .indigo)
    }
    
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
    
    func updateTime(selectedDate:Date) async
    {
        let data = await sleepService.fetchSleepDuration(endDate: selectedDate)
        inBedHours = String(Int(data.0 / 60))
        inBedMin = String(Int(data.0)%60)
    }
    
}
