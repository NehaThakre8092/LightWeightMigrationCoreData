//
//  CoreDataDemoApp.swift
//  CoreDataDemo
//
//  Created by Orangebits iOS User on 10/11/25.
//

import SwiftUI

@main
struct CoreDataDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            UserPassportDetails()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
