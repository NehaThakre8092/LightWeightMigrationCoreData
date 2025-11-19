//
//  ContentView.swift
//  CoreDataDemo
//
//  Created by Orangebits iOS User on 10/11/25.
//

import SwiftUI
import CoreData
import SwiftUI
import CoreData

struct APIResponse: Codable, Identifiable {
    var id: Int
    var name: String
    var hobbies: [String]
    var colorHex: String
    var email: String
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    @State private var decodedItems: [APIResponse] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(decodedItems) { item in
                    NavigationLink(destination: DetailsView(item: item)) {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.hobbies.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
                .background(Color.gray)
            }.listStyle(.plain)
            .navigationTitle("API Responses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                fetchData()
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            let response = APIResponse(
                id: Int.random(in: 1...100),
                name: "Neha \(Int.random(in: 5...10))",
                hobbies: ["Reading", "Coding", "Painting"],
                colorHex: "#FF5733",
                email: "n@gmail.com"
            )
            
            do {
                let data = try JSONEncoder().encode(response)
                newItem.details = data as NSObject
                try viewContext.save()
                fetchData()
            } catch {
                print("❌ Save error: \(error)")
            }
        }
    }
    
    private func fetchData() {
        decodedItems = items.compactMap { item in
            if let data = item.details as? Data,
               let decoded = try? JSONDecoder().decode(APIResponse.self, from: data) {
                
                return decoded
            }
            return nil
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
                fetchData()
            } catch {
                print("❌ Delete error: \(error)")
            }
        }
    }
}

struct DetailsView: View {
    let item: APIResponse
    
    var body: some View {
        VStack(spacing: 20) {
            Text(item.name)
                .font(.largeTitle)
                .bold()
            
            Text(item.email)
                .font(.largeTitle)
                .bold()
            
            
            Text("Hobbies:")
                .font(.headline)
            
            ForEach(item.hobbies, id: \.self) { hobby in
                Text("• \(hobby)")
                    .font(.body)
            }
        }
        .padding()
        .navigationTitle("Details")
    }
}
