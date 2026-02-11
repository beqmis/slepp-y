//
//  slepp_yApp.swift
//  slepp'y
//
//  Created by Яков Демиденко on 25.01.2026.
//

import SwiftUI

@main
struct slepp_yApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                // Первая вкладка
                MainView(
                    ringVM: RingsViewModel(sleepService: HKSleepService()),
                    mainVM: MainViewModel()
                )
                .tabItem {
                    Label("Анализ", systemImage: "zzz")
                }
                
                // Вторая вкладка (пример)
                Text("Настройки или профиль")
                    .tabItem {
                        Label("Профиль", systemImage: "person.circle")
                    }
            }
//            MainView(
//                ringVM: RingsViewModel(sleepService: HKSleepService()),
//                mainVM: MainViewModel())
        }
    }
}
