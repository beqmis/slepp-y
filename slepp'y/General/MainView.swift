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
    let sizer:Double = 0.75
    
    let coreColor = Color.blue
    let remColor = Color.cyan
    let deepColor = Color.indigo
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                VStack(alignment: .leading)
                {
                    Text("Анализ сна")
                        .font(.system(.title, design: .rounded))
                        .bold()
                    
                    Text(Date.now.format("EEEE, MMM d"))
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            
            
            analyticsView
            
            Spacer()
        }
        .padding()
    }
    
    private func statRow(title: String, value: Double, color: Color, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption.bold())
                    .textCase(.uppercase)
            }
            .foregroundColor(color)
            
            Text("\(Int(value))%")
                .font(.system(.title3, design: .rounded))
                .monospacedDigit()
                .bold()
        }
    }
    
    var analyticsView: some View {
        HStack(spacing: 20) {
            sleepRingView
            
            VStack(alignment: .leading, spacing: 16) {
                statRow(title: "Core", value: viewModel.coreRing.percent, color: coreColor, icon: "zzz")
                statRow(title: "Rem", value: viewModel.remRing.percent, color: remColor, icon: "eye")
                statRow(title: "Deep", value: viewModel.deepRing.percent, color: deepColor, icon: "moon.stars.fill")
            }
            .padding(.vertical)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    var sleepRingView: some View {
        ZStack {
            SingleRingView(model: viewModel.coreRing, ringWidth: 40*sizer)
                .frame(width: 300*sizer, height: 300*sizer)
            
            SingleRingView(model: viewModel.remRing, ringWidth: 40*sizer)
                .frame(width: 218*sizer, height: 218*sizer)
            
            SingleRingView(model: viewModel.deepRing, ringWidth: 40*sizer)
                .frame(width: 136*sizer, height: 136*sizer)
        }
        .onAppear {
            Task { await viewModel.updateRings() }
        }
    }
}

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

#Preview
{
    MainView(viewModel: RingsViewModel(sleepService: HKSleepService()))
}
