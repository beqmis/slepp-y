//
//  DetectorViewModel.swift
//  slepp'y
//
//  Created by Яков Демиденко on 04.02.2026.
//

import Foundation
import SwiftUI
import Combine

class DetectorViewModel: DetectorServiceProtocol, ObservableObject
{
    @Published var selectedHour: CGFloat = 12.0
//    {
//        didSet { if !isLoading { saveData() }}
//    }
    @Published var isSectionActive: Bool = false
//    {
//        didSet { if !isLoading { saveData() }}
//    }
    @Published var datePickerSelectedDate:Date
    {
        didSet { fetchData() }
    }
    
    @Published var isDragging: Bool = false
    {
        didSet { if !isLoading && !isDragging { saveData() }}
    }
    @Published var totalHours: Int = 24
    @Published var highlightDuration: CGFloat
    @Published var iconName: String
    
    private let storage:DetectorStorageServiceProtocol
    private var isLoading:Bool = false
    
    
    init(highlightDuration: CGFloat,
         iconName: String,
         storage:DetectorStorageServiceProtocol,
         date:Date)
    {
        self.highlightDuration = highlightDuration
        self.iconName = iconName
        self.storage = storage
        self.datePickerSelectedDate = date
    }
    
    func formatHour(_ hour: CGFloat) -> String {
        let totalMin = Int((hour * 60).rounded()) % 1440
        return String(format: "%02d:%02d", totalMin / 60, totalMin % 60)
    }
    
    private func fetchData() {
        //почему не селф
        isLoading = true
        
        self.selectedHour = storage.fetch(for: datePickerSelectedDate, key: "\(iconName)_hour") ?? 12.0
        self.isSectionActive = storage.fetch(for: datePickerSelectedDate, key: "\(iconName)_isActive") ?? false
        
        isLoading = false
    }
    
    private func saveData() {
        storage.save(selectedHour, for: datePickerSelectedDate, key: "\(iconName)_hour")
        storage.save(isSectionActive, for: datePickerSelectedDate, key: "\(iconName)_isActive")
        print("data saved for \(Int(selectedHour)) with \(isSectionActive) for \(datePickerSelectedDate) by \(iconName)")
    }
}

protocol DetectorServiceProtocol {
    var selectedHour: CGFloat { get set }
    var isDragging: Bool { get set }
    var highlightDuration: CGFloat { get }
    var iconName: String { get }
    
    func formatHour(_ hour: CGFloat) -> String
}


