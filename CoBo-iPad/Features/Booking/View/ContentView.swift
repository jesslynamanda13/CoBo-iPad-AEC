import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var dataViewModel: DataViewModel

    var body: some View {
        TabView {
            BookSpaceView(
                bookSpaceViewModel: BookSpaceViewModel(),
                collabSpaceViewModel: CollabSpaceViewModel(
                    selectedDate: Date(),
                    database: dataViewModel.database
                ),
                userViewModel: UserViewModel(database: dataViewModel.database)
            )
            .tabItem {
                Label("Book Space", systemImage: "calendar.badge.plus")
            }

            BookingLogView(bookingLogViewModel: BookingLogViewModel(selectedDate: Date(), database: dataViewModel.database), userViewModel: UserViewModel(database: dataViewModel.database))
                           
                .tabItem {
                    Label("Booking Log", systemImage: "list.bullet.rectangle")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataViewModel())
}

