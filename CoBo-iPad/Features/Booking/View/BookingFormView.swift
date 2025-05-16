//
//  BookingFormView.swift
//  CoBo-iPad
//
//  Created by Amanda on 14/05/25.
//

import SwiftUI

struct BookingFormView: View {
    var selectedDate: Date
    var selectedCollabSpace: CollabSpace
    var selectedTimeslot: Timeslot
    
    @State private var step = 1
    @StateObject var userVM : UserViewModel
    @State private var selectedUser: User? = nil
    @State private var navigateToSummary = false
    @FocusState private var isMeetingNameFocused: Bool
    
    @State var meetingName: String = ""
    @State private var selectedPurpose: BookingPurpose? = nil
    @State private var selectedParticipants: [User] = []
    
    // Toast
    @State private var showToast = false
    @State private var toastMessage = ""

    
    let darkerGrayColor = Color(red: 200/255, green: 200/255, blue: 200/255)

    
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 12){
                    Image("book-form-icon")
                        .resizable()
                        .frame(maxWidth: 120, maxHeight: 120)
                        .padding(.bottom, 12)
                    Text("Book Collab Space").font(.title).fontWeight(.bold)
                    Text("Please fill in the fields in the booking form.")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                ScrollView{
                    VStack(alignment: .leading, spacing: 32){
                        Text("Booking Form").font(.title2).fontWeight(.bold)
                        // space information
                        VStack(alignment: .leading, spacing: 24){
                            Text("Space Information").font(.title3).fontWeight(.bold).padding(.bottom, 12)
                            // date
                            HStack{
                                Text("Date").font(.body)
                                Spacer()
                                Text(formatDate(selectedDate)).font(.body).fontWeight(.semibold)
                            }
                            Divider()
                            HStack{
                                Text("Time").font(.body)
                                Spacer()
                                Text("\(selectedTimeslot.doubleToTime(selectedTimeslot.startHour)) - \(selectedTimeslot.doubleToTime(selectedTimeslot.endHour))").font(.body).fontWeight(.semibold)
                            }
                            Divider()
                            HStack{
                                Text("Space").font(.body)
                                Spacer()
                                Text("\(selectedCollabSpace.name)").font(.body).fontWeight(.semibold)
                            }
                            Divider()
                        }.frame(maxWidth: 650)
                        
                        VStack(alignment: .leading, spacing: 24){
                            Text("Meeting Details").font(.title3).fontWeight(.bold)
                            
                            VStack(alignment: .leading, spacing: 12){
                                Text("Coordinator").font(.body)
                                VStack {
                                    if userVM.users.isEmpty {
                                        ProgressView("Loading users...")
                                    } else {
                                        let users: [User] = userVM.users
                                        SearchableDropdownComponent<User>(selectedItem: $selectedUser, data: users)
                                            .onChange(of: selectedUser) { user in
                                                if let user = user {
                                                    meetingName = "\(user.name)'s Meeting"
                                                } else {
                                                    meetingName = ""
                                                }
                                            }
                                        
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12){
                                Text("Meeting name").font(.body)
                                TextField("Group Meeting", text: $meetingName)
                                    .padding()
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(darkerGrayColor, lineWidth: 1)
                                    )
                                    .font(.system(.callout))
                                    .focused($isMeetingNameFocused)
                        }
                            VStack(alignment: .leading, spacing: 12){
                                Text("Purpose").font(.body)
                                BookingPurposeDropdownComponent(selectedItem: $selectedPurpose)
                                
                            }
                      
                            
                            

                        }
                        
                        VStack(alignment: .leading, spacing: 12){
                            Text("Meeting Participants").font(.title3).fontWeight(.bold)
                            Text("By adding participants, you automatically include them as invitees in CoBo’s generated iCal event.").font(.body)
                            if userVM.users.isEmpty {
                                ProgressView("Loading users...")
                            } else {
                                let users: [User] = userVM.users
                                MultipleSelectionDropdownComponent(selectedData: $selectedParticipants, allData: users)
                                                    .padding(.bottom)
                            }
                            
                        }
                        
                       
                    }.frame(maxWidth: 650)
                    
                    
                }
                
            }.padding(.horizontal, 32).padding(.top, 32).padding(.bottom, 128)
            
                .overlay(
                    Group{
                        VStack(spacing: 12){
                            ThreeStepProgressBar(currentStep: step)
                            Button(
                                action:{
                                    if selectedUser == nil {
                                           toastMessage = "Please select a coordinator."
                                           showToast = true
                                       } else if meetingName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                           toastMessage = "Please enter a meeting name."
                                           showToast = true
                                       } else if selectedPurpose == nil {
                                           toastMessage = "Please select a purpose."
                                           showToast = true
                                       } else {
                                           navigateToSummary = true
                                       }
                                }
                            ){
                                Text("Book")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .font(.title3)
                                    .padding(.vertical, 18)
                                    .foregroundColor(.white).background(Color.purple)
                                    .cornerRadius(12)
                                
                            }
                            NavigationLink(destination: bookingSummaryDestination, isActive: $navigateToSummary) {
                                EmptyView()
                            }
                            .hidden()

                        }
                        .padding()
                        .background(Color.white)
                       
                    },
                    
                    alignment: .bottom
                )
                .onAppear{
                    userVM.fetchUsers()
                }
                .padding(.horizontal, 16)
                .safeAreaPadding(.all)
                .navigationTitle("Book Space")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        EmptyView()
                    }
                }
                .toolbar(.hidden, for: .tabBar)
        }.overlay(
            VStack {
                if showToast {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.black)
                        Text(toastMessage)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.95))
                    .cornerRadius(12)
                    .padding(.top, 50)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
                }

                Spacer()
            },
            alignment: .top
        )
        
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: date)
    }
    
    @ViewBuilder
    private var bookingSummaryDestination: some View {
        if let selectedUser = selectedUser,
           let selectedPurpose = selectedPurpose {
            BookingSummaryView(
                selectedDate: selectedDate,
                selectedCollabSpace: selectedCollabSpace,
                selectedTimeslot: selectedTimeslot,
                coordinator: selectedUser,
                meetingName: meetingName,
                purpose: selectedPurpose,
                participants: selectedParticipants
            )
        } else {
            EmptyView()
        }
    }



    
}
