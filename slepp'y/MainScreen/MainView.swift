//
//  MainView.swift
//  slepp'y
//
//  Created by Яков Демиденко on 25.01.2026.
//

import SwiftUI

struct MainView:View
{
    @StateObject var ringVM:RingsViewModel
    @StateObject var mainVM:MainViewModel
    
    let sizer:Double = 0.75
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                headerView
                
                analyticsView
                
                Spacer()
            }
            .padding()
            .blur(radius: mainVM.isDatePickerShowing ? 10 : 0)
            .animation(.easeInOut(duration: 0.3), value: mainVM.isDatePickerShowing)
            .disabled(mainVM.isDatePickerShowing)
            
            if mainVM.isDatePickerShowing
            {
                calendarDatePickeView
                .transition(.opacity)
                .zIndex(1)
            }
        }
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
                statRow(title: "Core", value: ringVM.coreRing.percent, color: Color.sleepCore, icon: "zzz")
                statRow(title: "Rem", value: ringVM.remRing.percent, color: Color.sleepRem, icon: "eye")
                statRow(title: "Deep", value: ringVM.deepRing.percent, color: Color.sleepDeep, icon: "moon.stars.fill")
            }
            .padding(.vertical)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    var headerView: some View {
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
            Button() {
                withAnimation(.easeInOut(duration: 0.3))
                {
                    mainVM.isDatePickerShowing.toggle()
                }
                
            } label: {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }
    
    var sleepRingView: some View {
        ZStack {
            SingleRingView(model: ringVM.coreRing, ringWidth: 40*sizer)
                .frame(width: 300*sizer, height: 300*sizer)
            
            SingleRingView(model: ringVM.remRing, ringWidth: 40*sizer)
                .frame(width: 218*sizer, height: 218*sizer)
            
            SingleRingView(model: ringVM.deepRing, ringWidth: 40*sizer)
                .frame(width: 136*sizer, height: 136*sizer)
        }
        .onAppear {
            Task { await ringVM.updateRings() }
        }
    }
    
    var calendarDatePickeView: some View {
        VStack
        {
            DatePicker(
                "Start Date",
                selection: $mainVM.selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            
            Button("Select")
            {
                withAnimation(.easeInOut(duration: 0.3)) {
                    mainVM.isDatePickerShowing.toggle()
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.sleepCore)
            .cornerRadius(12)
            .padding()
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.2), radius: 20)
        .padding(.horizontal, 30)
    }
}



#Preview
{
    MainView(ringVM: RingsViewModel(sleepService: HKSleepService()), mainVM: MainViewModel())
}



