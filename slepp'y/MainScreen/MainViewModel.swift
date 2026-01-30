//
//  MainViewModel.swift
//  slepp'y
//
//  Created by Яков Демиденко on 30.01.2026.
//
import Foundation
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var isDatePickerShowing = false
    
    func toggleDatePicker() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDatePickerShowing.toggle()
        }
    }
}

extension Color {
    static let sleepCore = Color.blue
    static let sleepRem = Color.cyan
    static let sleepDeep = Color.indigo
}

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
