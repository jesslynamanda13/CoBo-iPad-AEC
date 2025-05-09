//
//  CalendarComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//
import SwiftUI

struct CalendarComponent: View {
    @Binding var selectedDate:Date
    @State private var color:Color = .purple
    @State private var date = Date.now
    @State private var holidays: [HolidayDate] = []
    
    let daysOfWeek: [String] = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let daysInRange : [Date] = Date.now.nextSevenWeekdays()
    
    @State private var days : [Date] = []
    
    func isBeforeToday(_ dateCheck: Date) -> Bool {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        return dateCheck < startOfToday
    }
    
    func checkIfDateIsInRange(_ day: Date) -> Bool {
        let daysInRange: [Date] = Date.now.nextSevenWeekdays()
        return daysInRange.contains(where: { $0.isSameDay(as: day) })
    }
    
    func checkIfDateIsHoliday(_ day: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return holidays.contains(where: { holiday in
                   guard  let holidayDate = formatter.date(from: holiday.holiday_date)
                else { return false }
                
                return holidayDate.isSameDay(as: day)
            })
    }

    
    func goToPreviousMonth() {
        date = Calendar.current.date(byAdding: .month, value: -1, to: date) ?? date
    }
    
    func goToNextMonth() {
        date = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? date
    }
    
    func fetchHolidays() {
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        let urlString = "https://api-harilibur.vercel.app/api?month=\(month)&year=\(year)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let holidaysResponse = try decoder.decode([HolidayDate].self, from: data)
                    DispatchQueue.main.async {
                        holidays = holidaysResponse.filter { $0.is_national_holiday }.reversed()

                    }
                } catch {
                    print("Error decoding holiday data: \(error)")
                }
            }
        }.resume()
        
    }
    
    
    var body: some View {
        VStack{
            HStack() {
                Text(date.formatted(.dateTime.month().year()))
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                HStack(spacing: 24){
                    Button(action: goToPreviousMonth) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(Color.purple)
                    }
                    Button(action: goToNextMonth) {
                        Image(systemName: "chevron.right")
                            .font(.headline)
                            .foregroundStyle(Color.purple)
                    }
                }
               
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom,24)
            HStack{
                ForEach(daysOfWeek.indices, id: \.self){
                    index in
                    Text(daysOfWeek[index])
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns){
                ForEach(days, id: \.self){ day in
                    if checkIfDateIsHoliday(day){
                        Text(day.formatted(.dateTime.day()))
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color.red)
                            .frame(maxWidth: .infinity, minHeight: 40)
                    }
                    else if day.monthInt != date.monthInt
                        || !checkIfDateIsInRange(day) ||
                        isBeforeToday(day){
                        Text(day.formatted(.dateTime.day()))
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, minHeight: 40)
                    }
                    else if selectedDate.isSameDay(as: day) {
                        Text(day.formatted(.dateTime.day()))
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color.purple)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle().fill(Color("Light-Purple")).stroke(Color.purple, lineWidth: 1)
                            )
                    }
                    else if checkIfDateIsInRange(day){
                        Text(day.formatted(.dateTime.day()))
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .onTapGesture {
                                selectedDate = day
                            }
                    }
                    
                }
            }
            .padding(.top,12)
            .padding(.bottom, 16)
            Divider()
            if !holidays.isEmpty{
                VStack{
                    Text("Holidays 🏖️").font(.body)
                        .padding(.bottom, 8).frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.semibold)
                    ForEach(holidays){
                        holiday in
                        HStack(alignment: .top, spacing: 12){
                            Circle().fill(Color.red).frame(width: 10, height: 10).padding(.top, 4)
                            VStack{
                                Text(holiday.formattedDate ?? "").font(.callout).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .leading)
                                    
                                Text(holiday.holiday_name).font(.footnote).frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
            }
            
            
        }
        
        .onAppear{
            days = date.calendarDisplayDays
            fetchHolidays()
            
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
            fetchHolidays()
        }
    }
}

