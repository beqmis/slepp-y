//
//  Models.swift
//  slepp'y
//
//  Created by Яков Демиденко on 26.01.2026.
//
import SwiftUI

enum SleepTypeModel:CaseIterable {
    case awake
    case asleepCore
    case asleepDeep
    case asleepREM
}

struct RingTypeModel {
    var percent: Double
    let backgroundColor: Color
    let foregroundColor: Color
}
