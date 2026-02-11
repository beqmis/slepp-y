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
    @Published var isDragging: Bool = false
    @Published var totalHours: Int = 24
    @Published var isSectionActive: Bool = false
    @Published var highlightDuration: CGFloat
    @Published var iconName: String

    
    init(highlightDuration: CGFloat,iconName: String) {
        self.highlightDuration = highlightDuration
        self.iconName = iconName
    }
    
    func formatHour(_ hour: CGFloat) -> String {
        let totalMin = Int((hour * 60).rounded()) % 1440
        return String(format: "%02d:%02d", totalMin / 60, totalMin % 60)
    }
}

protocol DetectorServiceProtocol {
    var selectedHour: CGFloat { get set }
    var isDragging: Bool { get set }
    var highlightDuration: CGFloat { get }
    var iconName: String { get }
    
    func formatHour(_ hour: CGFloat) -> String
}


