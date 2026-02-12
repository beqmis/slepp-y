//
//  CoffeeDetectorView.swift
//  slepp'y
//
//  Created by Яков Демиденко on 06.02.2026.
//

import SwiftUI

struct GenericDetectorView: View {
    
    @StateObject var viewModel:DetectorViewModel
    var selectedDate: Date
    var body: some View {
        VStack() {
            HStack(alignment: .top) {
                Toggle(isOn: $viewModel.isSectionActive)
                {
                    
                }
                .labelsHidden()
                .padding(.top, 4)
                
                Spacer()
                VStack(alignment: .leading) {
                    Text("Время действия: \(viewModel.formatHour(viewModel.selectedHour))")
                        .font(.headline)
                    Text("Время двух полураспадов: \(viewModel.formatHour(viewModel.selectedHour + (viewModel.highlightDuration * 2)))")
                        .font(.headline)
                }
            }
            .padding(.bottom, 50)
            
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let step = width / CGFloat(viewModel.totalHours)
                
                ZStack(alignment: .leading) {
                    // 1. Отрисовка цветной штриховки (будущий эффект)
                    if !viewModel.isDragging {
                        Rectangle()
                            .fill(Color.red.opacity(0.3))
                            .frame(width: step * viewModel.highlightDuration, height: 20)
                            .offset(x: step * viewModel.selectedHour)
                        Rectangle()
                            .fill(Color.yellow.opacity(0.3))
                            .frame(width: step * viewModel.highlightDuration, height: 20)
                            .offset(x: step * (viewModel.selectedHour + viewModel.highlightDuration))
                        Rectangle()
                            .fill(Color.green.opacity(0.3))
                            .frame(width: step * viewModel.highlightDuration, height: 20)
                            .offset(x: step * (
                                viewModel.selectedHour +
                                viewModel.highlightDuration +
                                viewModel.highlightDuration))
                    }
                    
                    // 2. Основная линия с отметками
                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(0...viewModel.totalHours, id: \.self) { hour in
                            VStack(spacing: 4) {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 1, height: hour % 6 == 0 ? 20 : 10)
                                Text("\(hour)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: hour == viewModel.totalHours ? 1 : step, alignment: .leading)
                        }
                    }
                    .frame(height: 40)
                    
                    // 3. Метка (Pin)
                    VStack(spacing: 0) {
                        Image(systemName: viewModel.iconName)
                            .font(.title)
                            .foregroundColor(.primary)
                            .offset(y: -30)
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                    }
                    .offset(x: (step * viewModel.selectedHour) - 12) // Центрируем pin
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                viewModel.isDragging = true
                                let newHour = value.location.x / step
                                // Ограничиваем диапазон от 0 до 23
                                viewModel.selectedHour = min(max(0, newHour), CGFloat(viewModel.totalHours))
                            }
                            .onEnded { _ in
                                viewModel.isDragging = false
                            }
                    )
                }
            }
            .frame(height: 80)
            .blur(radius: viewModel.isSectionActive ? 0 : 2)
            .opacity(viewModel.isSectionActive ? 1 : 0.5)
            .disabled(!viewModel.isSectionActive)
            .animation(.easeInOut, value: viewModel.isSectionActive)
        }
        .onChange(of: selectedDate) { newDate in
            viewModel.datePickerSelectedDate = newDate
        }
        
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
