//
//  HKSleepService.swift
//  slepp'y
//
//  Created by Яков Демиденко on 27.01.2026.
//
import HealthKit

class HKSleepService: SleepServiceProtocol,SleepAuthorizationProtocol,SleepDurationProtocol {
    
    private let healthStore = HKHealthStore()
    private let sleepType = HKCategoryType(.sleepAnalysis)
    
    
    private func fetchRawSleepData(endDate: Date) async -> [HKCategorySample] {
        guard HKHealthStore.isHealthDataAvailable() else {return []}
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: endDate)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.sample(type: sleepType, predicate: predicate)],
            sortDescriptors: []
        )
        do {
            let results = try await descriptor.result(for: healthStore)
            return results.compactMap { $0 as? HKCategorySample }
        } catch {
            print("Ошибка загрузки HealthKit: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchSleepData(endDate: Date) async -> (core: Double, rem: Double, deep: Double) {
        
        let samples = await fetchRawSleepData(endDate: endDate)
        
        var core: Double = 0
        var rem: Double = 0
        var deep: Double = 0
        
        for sample in samples {
            
            let duration = sample.endDate.timeIntervalSince(sample.startDate) / 60
            
            switch sample.value {
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
    
    
    func requestAuthorization() async -> Bool {
        let typesToRead: Set = [sleepType]
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
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
    
    func fetchSleepDuration(endDate: Date) async -> (inBed: Double, asleep: Double) {
        guard HKHealthStore.isHealthDataAvailable() else {return (0, 0)}
        
        let samples = await fetchRawSleepData(endDate: endDate)
        
        var inBed:Double = 0
        var asleep:Double = 0
        
        for sample in samples {
            let duration = sample.endDate.timeIntervalSince(sample.startDate) / 60
            
            if sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
                inBed += duration
            }
            
            else if [HKCategoryValueSleepAnalysis.asleepCore.rawValue,
                     HKCategoryValueSleepAnalysis.asleepDeep.rawValue,
                     HKCategoryValueSleepAnalysis.asleepREM.rawValue,
                     HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue].contains(sample.value) {
                asleep += duration
            }
        }
        
        print("inBed: \(inBed), asleep: \(asleep)")
        return (inBed, asleep)
    }
}


protocol SleepServiceProtocol {
    func fetchSleepData(endDate:Date) async -> (core: Double, rem: Double, deep: Double)
}

protocol SleepAuthorizationProtocol {
    func requestAuthorization() async -> Bool
}

protocol SleepDurationProtocol {
    func fetchSleepDuration(endDate:Date) async -> (inBed:Double, asleep:Double)
}
