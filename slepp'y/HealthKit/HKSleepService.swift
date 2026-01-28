//
//  HKSleepService.swift
//  slepp'y
//
//  Created by Яков Демиденко on 27.01.2026.
//
import HealthKit

class HKSleepService: SleepServiceProtocol,SleepAuthorizationProtocol {
    
    private let helthStore = HKHealthStore()
    private let sleepType = HKCategoryType(.sleepAnalysis)
    
    func fetchSleepData() async -> (core: Double, deep: Double, rem: Double) {
        
        guard HKHealthStore.isHealthDataAvailable() else {return (0, 0, 0)}
        
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.startOfDay(for: endDate)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.sample(type: sleepType, predicate: predicate)],
            sortDescriptors: []
        )
        do {
            let results = try await descriptor.result(for: helthStore)
            
            var core: Double = 0
            var deep: Double = 0
            var rem: Double = 0
            
            for result in results {
                guard let sleepSample = result as? HKCategorySample else {continue}
                
                let duration = sleepSample.endDate.timeIntervalSince(sleepSample.startDate) / 60
                
                switch sleepSample.value {
                case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                    core += duration
                case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                    deep += duration
                case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                    rem += duration
                default: break
                }
                
            }
            print(core, deep, rem)
            return (core, deep, rem)
        }
        catch {
            print("Ошибка загрузки данных сна: \(error.localizedDescription)")
            return (0, 0, 0)
        }
    }
    func requestAuthorization() async -> Bool {
        let typesToRead: Set = [sleepType]
            
            do {
                try await helthStore.requestAuthorization(toShare: [], read: typesToRead)
                return true
            } catch {
                print("Ошибка авторизации: \(error.localizedDescription)")
                return false
            }
    }
}


protocol SleepServiceProtocol {
    func fetchSleepData() async -> (core: Double, deep: Double, rem: Double)
}

protocol SleepAuthorizationProtocol {
    func requestAuthorization() async -> Bool
}
