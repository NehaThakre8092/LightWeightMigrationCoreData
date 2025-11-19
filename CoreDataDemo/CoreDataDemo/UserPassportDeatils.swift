import SwiftUI
import CoreData

struct UserPassportDetails: View {

    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.firstName, ascending: true)],
        animation: .default
    )
    private var users: FetchedResults<User>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users) { user in
                    VStack(alignment: .leading) {
                        Text(user.firstName ?? "")
                            .font(.headline)
                        
                        Text("Email: \(user.email ?? "NA")")
                            .font(.subheadline)
                        
                        if let date = user.passport?.expireDate {
                            Text("Expires: \(formattedDate(date))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addData) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("User Passports")
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func deleteItems(offsets: IndexSet) {
        offsets.map { users[$0] }.forEach(viewContext.delete)
        try? viewContext.save()
    }
    
    private func addData() {
        let newUser = User(context: viewContext)
        newUser.firstName = "Neha\(Int.random(in: 1...5))"
        newUser.secondName = "Singh"
        
        newUser.email = "Neha\(Int.random(in: 1...5))@gmail.com"
        
        let passport = Passport(context: viewContext)
        passport.number = "123456789"
        
        let dateString = "2025-12-31"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            passport.expireDate = Calendar.current.startOfDay(for: date)
        }
        
        newUser.passport = passport
        
        let task = Task(context: viewContext)
        task.name = "Education"
        task.details = "Complete BCA"
        newUser.task = task
        
        do {
            try viewContext.save()
        } catch {
            print("❌ Save error: \(error)")
        }
    }
}
