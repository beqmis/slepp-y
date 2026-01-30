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
    
    func fetchSleepData(endDate: Date) async -> (core: Double, rem: Double, deep: Double) {
        
        guard HKHealthStore.isHealthDataAvailable() else {return (0, 0, 0)}
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: endDate)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.sample(type: sleepType, predicate: predicate)],
            sortDescriptors: []
        )
        do {
            let results = try await descriptor.result(for: helthStore)
            
            var core: Double = 0
            var rem: Double = 0
            var deep: Double = 0
            
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
            print(minutes2percent(core: core, rem: rem, deep: deep))
            return minutes2percent(core: core, rem: rem, deep: deep)

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
    func minutes2percent(core: Double, rem: Double, deep: Double) -> (Double,Double,Double) {
        let sleepTime: Double = 480
        
        return ((core/sleepTime)*100, (rem/sleepTime)*100, (deep/sleepTime)*100)
    }
}


protocol SleepServiceProtocol {
    func fetchSleepData(endDate:Date) async -> (core: Double, rem: Double, deep: Double)
}

protocol SleepAuthorizationProtocol {
    func requestAuthorization() async -> Bool
}
