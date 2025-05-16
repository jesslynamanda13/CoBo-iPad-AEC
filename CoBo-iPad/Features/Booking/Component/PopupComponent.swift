//
//  PopupComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 14/05/25.
//
import SwiftUI

struct PopupComponent : View{
    @Binding var selectedDate : Date
    @Binding var selectedCollabSpace : CollabSpace
    @Binding var selectedTimeslot : Timeslot
    var onBookNow: () -> Void
    @State private var navigateToForm = false
    var body : some View{
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 16){
                        Text("Book Space").font(.title3).fontWeight(.bold)
                        HStack(spacing: 12){
                            HStack{
                                Image(systemName: "calendar").font(.subheadline)
                                Text("\(formattedDate(selectedDate))").font(.subheadline)
                            }
                            Divider().frame(height: 20)
                            HStack{
                                Image(systemName: "clock").font(.subheadline)
                                Text("\(selectedTimeslot.doubleToTime(selectedTimeslot.startHour)) - \(selectedTimeslot.doubleToTime(selectedTimeslot.endHour))").font(.subheadline)
                            }
                            Divider().frame(height: 20)
                            HStack{
                                Image(systemName: "house").font(.subheadline)
                                Text("\(selectedCollabSpace.name)").font(.subheadline)
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


