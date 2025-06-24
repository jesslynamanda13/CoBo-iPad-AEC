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
    var isSelected : Bool
    var collabSpace : CollabSpace
    var selectedCollabSpace : CollabSpace?
    var body: some View{
        if !isAvailable{
            Text("\(timeslot.doubleToTime(timeslot.startHour)) - \(timeslot.doubleToTime(timeslot.endHour))")
                .foregroundColor(.gray)
                .fontWeight(.medium)
                .font(.system(size: 15))
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.gray.opacity(0.3))
                )
        }
        else if isSelected && collabSpace == selectedCollabSpace{
            Text("\(timeslot.doubleToTime(timeslot.startHour)) - \(timeslot.doubleToTime(timeslot.endHour))")
                .fontWeight(.medium)
                .foregroundStyle(Color.purple)
                .font(.system(size: 15))
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("Light-Purple"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.purple, lineWidth: 1)
                            )
                    )
        }
        else{
            Text("\(timeslot.doubleToTime(timeslot.startHour)) - \(timeslot.doubleToTime(timeslot.endHour))")
                .fontWeight(.medium)
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
