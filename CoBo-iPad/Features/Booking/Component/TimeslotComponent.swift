//
//  TimeslotComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 07/05/25.
//
import SwiftUI
struct TimeslotComponent : View{
    var timeslot : Timeslot
    var isAvailable: Bool
    var body: some View{
        if !isAvailable{
            Text("\(timeslot.doubleToTime(timeslot.startHour)) - \(timeslot.doubleToTime(timeslot.endHour))")
                .foregroundColor(.gray)
                .fontWeight(.regular)
                .font(.system(size: 15))
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.gray.opacity(0.3))
                )
        }
        else{
            Text("\(timeslot.doubleToTime(timeslot.startHour)) - \(timeslot.doubleToTime(timeslot.endHour))")
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
