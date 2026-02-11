//
//  DetectorView.swift
//  slepp'y
//
//  Created by Яков Демиденко on 04.02.2026.
//
import SwiftUI

struct DetectorView: View {
    var body: some View {
        ZStack()
        {
            VStack()
            {
                GenericDetectorView(
                    viewModel: DetectorViewModel(
                        highlightDuration: 5.5,
                        iconName: "cup.and.heat.waves.fill"))
                
                GenericDetectorView(
                    viewModel: DetectorViewModel(
                        highlightDuration: 1.0,
                        iconName: "figure.run"))
                
                GenericDetectorView(
                    viewModel: DetectorViewModel(
                        highlightDuration: 2.0,
                        iconName: "wineglass"))
                
            }
        }
        .ignoresSafeArea(.all)
    }
    
}

#Preview {
    DetectorView()
}
