//
//  BookSpaceView.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//
import SwiftUI

struct BookSpaceView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    @State private var selectedDate: Date = Date.now
    
    var body: some View {
        VStack {
                ZStack{
                    Image("bg-bookspace")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 120)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Book Collab Space")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Find and book Collab Space that fits your needs and availability.")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .safeAreaPadding(.all)
                    .padding(.horizontal, 16)
                }
            HStack(alignment: .top, spacing: 32){
                CalendarComponent().frame(maxWidth: 350).padding(.top, 12)
            
                CollabspaceManager()
                
                
               
            }
            .safeAreaPadding(.all)
            .padding(.horizontal, 16)
        }
    
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

