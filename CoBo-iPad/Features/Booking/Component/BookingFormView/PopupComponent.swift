//
//  PopupComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 14/05/25.
//
import SwiftUI

struct PopupComponent : View{
    var selectedDate : Date
    var selectedCollabSpace : CollabSpace
    var selectedTimeslot : Timeslot
    var onBookNow: () -> Void
    @State private var navigateToForm = false
    var body : some View{
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 16){
                        Text("Book Collab Space").font(.title2).fontWeight(.bold)
                        HStack(spacing: 12){
                            HStack{
                                Image(systemName: "calendar").font(.body)
                                Text("\(formattedDate(selectedDate))").font(.body)
                            }
                            Divider().frame(height: 20)
                            HStack{
                                Image(systemName: "clock").font(.body)
                                Text("\(selectedTimeslot.doubleToTime(selectedTimeslot.startHour)) - \(selectedTimeslot.doubleToTime(selectedTimeslot.endHour))").font(.body)
                            }
                            Divider().frame(height: 20)
                            HStack{
                                Image(systemName: "house").font(.body)
                                Text("\(selectedCollabSpace.name)").font(.body)
                            }
                            
                        }
                       
                        
                    }
                    Spacer()
                    Button(action: {
                        onBookNow()
                    }){
                        Text("Book")
                            .font(.headline)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 72)
                            .cornerRadius(12)
                            .foregroundColor(.white).background(Color.purple)
                            .cornerRadius(12)
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 32)
                .background(.white)
                
            }
            
        
        
        
    }
    
    func formattedDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "dd MMMM yyyy"
            return "Today, \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "EEEE, dd MMMM yyyy"
            return formatter.string(from: date)
        }
    }

}


