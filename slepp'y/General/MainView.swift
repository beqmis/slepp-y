//
//  MainView.swift
//  slepp'y
//
//  Created by Яков Демиденко on 25.01.2026.
//

import SwiftUI

struct MainView:View
{
    @StateObject var viewModel:RingsViewModel
    
    var body: some View {
        VStack{
            ZStack {
                SingleRingView(model: viewModel.coreRing, ringWidth: 40)
                    .frame(width: 300, height: 300)
                
                SingleRingView(model: viewModel.remRing, ringWidth: 40)
                    .frame(width: 218, height: 218)
                
                SingleRingView(model: viewModel.deepRing, ringWidth: 40)
                    .frame(width: 136, height: 136)
            }
            .onAppear {
                Task { await viewModel.updateRings() }
            }
            
            Spacer()
            Text("lol")
            
        }
        
    }
    
}

#Preview
{
    MainView(viewModel: RingsViewModel(sleepService: HKSleepService()))
}
