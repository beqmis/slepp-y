//
//  DetectorView.swift
//  slepp'y
//
//  Created by Яков Демиденко on 04.02.2026.
//
import SwiftUI

struct DetectorView: View {
    let date:Date
    let storage:DetectorStorageServiceProtocol = DetectorStorageService()
    
    var body: some View {
        ZStack()
        {
            VStack()
            {
                GenericDetectorView(
                    viewModel: DetectorViewModel(
                        highlightDuration: 5.5,
                        iconName: "cup.and.heat.waves.fill",
                        storage: storage,
                        date: date
                    )
                    ,selectedDate: date)
                
                GenericDetectorView(
                    viewModel: DetectorViewModel(
                        highlightDuration: 1.0,
                        iconName: "figure.run",
                        storage: storage,
                        date: date
                    )
                    ,selectedDate: date)
                
                GenericDetectorView(
                    viewModel: DetectorViewModel(
                        highlightDuration: 2.0,
                        iconName: "wineglass",
                        storage: storage,
                        date: date
                    )
                    ,selectedDate: date)
                
            }
        }
        .ignoresSafeArea(.all)
    }
    
}
