//
//  TimeslotComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 07/05/25.
//
import SwiftUI
struct TimeslotComponent : View{
    @Binding var isAvailable: Bool
    @Binding var timeSlot : Timeslot
    var body: some View{
        if !isAvailable{
            Text("\(timeSlot.doubleToTime(timeSlot.startHour)) - \(timeSlot.doubleToTime(timeSlot.endHour))")
                .foregroundColor(.gray)
                .fontWeight(.regular)
                .font(.system(size: 15))
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.gray.opacity(0.6))
                )
        }
        else{
            Text("\(timeSlot.doubleToTime(timeSlot.startHour)) - \(timeSlot.doubleToTime(timeSlot.endHour))")
                .fontWeight(.regular)
                .font(.system(size: 15))
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
                )
        }
        
    }
}
