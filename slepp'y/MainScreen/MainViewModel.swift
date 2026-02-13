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
    private static let sharedFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d"
        return df
    }()

    func formatWithShared() -> String {
        return Self.sharedFormatter.string(from: self)
    }
}
