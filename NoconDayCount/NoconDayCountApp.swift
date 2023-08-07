//
//  NoconDayCountApp.swift
//  NoconDayCount
//
//  Created by 金子広樹 on 2023/08/06.
//

import SwiftUI

@main
struct NoconDayCountApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, Locale(identifier: "ja_JP"))
        }
    }
}
