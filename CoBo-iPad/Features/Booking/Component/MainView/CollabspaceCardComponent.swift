//
//  CollabspaceCardComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 06/05/25.
//

import SwiftUI
struct CollabspaceCard : View{
    @EnvironmentObject var databaseVM: DataViewModel
    let collabSpaceVM: CollabSpaceViewModel
    let collabSpace: CollabSpace
    @Binding var selectedCollabSpace : CollabSpace?
    @Binding var selectedTimeslot : Timeslot?
    @Binding var selectedDate : Date
    @State private var timeslotVM: TimeslotViewModel? = nil
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(){
            HStack(alignment: .center){
                ImageCarouselComponent(images: collabSpace.images, locationUIImage: collabSpace.locationUIImage!, collabSpaceName: collabSpace.name)
                VStack(alignment: .leading, spacing: 12){
                    Text("\(collabSpace.name)")
                        .fontWeight(.bold)
                        .font(.headline)
                    HStack(alignment:.top){
                        VStack(alignment: .leading,spacing:6){
                            Text("Facilities")
                                .foregroundStyle(.gray)
                                .font(.footnote)
                            VStack(alignment: .leading, spacing: 4){
                                // if TV is available
                                if collabSpace.tvAvailable{
                                    HStack(alignment: .center){
                                        Image(systemName: "tv")
                                            .font(.footnote)
                                        Text("TV").font(.footnote)
                                        Spacer()
                                    }.frame(maxWidth: 80)
                                }
                                
                                // if table whiteboard is available
                                if collabSpace.tableWhiteboardAmount > 0{
                                    HStack(alignment: .top){
                                        Image(systemName: "pencil.line")
                                            .font(.footnote)
                                        if collabSpace.tableWhiteboardAmount > 1{
                                            Text("\(collabSpace.tableWhiteboardAmount) Table Whiteboards")
                                                .font(.footnote)
                                                .frame(maxWidth: 80, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(nil)
                                        }else{
                                            Text("\(collabSpace.tableWhiteboardAmount) Table Whiteboard")
                                                .font(.footnote)
                                                .frame(maxWidth: 80, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(nil)
                                        }
                                        
                                    }
                                }
                                if collabSpace.whiteboardAmount > 0{
                                    HStack(alignment: .top){
                                        Image(systemName: "pencil.line")
                                            .font(.footnote)
                                        if collabSpace.whiteboardAmount > 1{
                                            Text("\(collabSpace.whiteboardAmount) Whiteboards")
                                                .font(.footnote)
                                                .frame(maxWidth: 80, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(nil)
                                        }else{
                                            Text("\(collabSpace.whiteboardAmount) Whiteboard")
                                                .font(.footnote)
                                                .frame(maxWidth: 80, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(nil)
                                        }
                                        
                                    }
                                }
                                
                                
                            }
                            
                            
                        }
                        VStack(alignment: .leading, spacing:6) {
                            Text("Capacity")
                                .foregroundStyle(.gray)
                                .font(.footnote)
                            VStack(alignment: .leading){
                                HStack(alignment: .center){
                                    Image(systemName: "person")
                                        .font(.footnote)
                                    Text("8").font(.footnote)
                                }
                                
                            }
                            
                        }
                    }
                    
                }.padding(.horizontal, 16)
            }
            Divider().padding(.top, -8)
            // timeslot
            VStack(){
                HStack {
                    Text("Available Timeslot")
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                if let timeslotVM = timeslotVM {
                    TimeslotManager(
                        timeslotVM: timeslotVM,
                        collabSpace: collabSpace,
                        selectedCollabSpace: $selectedCollabSpace,
                        selectedTimeslot: $selectedTimeslot
                    )
                }

            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .onChange(of: selectedDate) { newDate in
            timeslotVM = collabSpaceVM.getTimeslotVM(for: collabSpace, database: databaseVM.database)
        }
        .onAppear {
            timeslotVM = collabSpaceVM.getTimeslotVM(for: collabSpace, database: databaseVM.database)
        }
    }
}


// TODO: Pindahin
struct TopLeftRoundedShape: Shape {
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 12
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
    }
}
