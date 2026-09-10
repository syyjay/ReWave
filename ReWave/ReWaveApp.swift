//
//  ReWaveApp.swift
//  ReWave
//
//  Created by syy on 9/9/26.
//

import SwiftUI
import ThemeKit

@main
struct ReWaveApp: App {
    @StateObject private var themeManager = ThemeManager(
        themes: [ReWaveTheme(), EmberTheme()],
        defaultTheme: ReWaveTheme()
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .themeManaged(by: themeManager)
                .environmentObject(themeManager)
        }
    }
}
