//
//  SearchableDropdownComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 15/05/25.
//



import SwiftUI
import SwiftData

// Search Coordinator Name
struct SearchableDropdownComponent<T:DropdownProtocol>: View {
    @State private var isExpanded = false
    @State private var dropdownLabel: String
    @State private var searchText = ""
    @Binding private var selectedItem: T?
    
    let darkerGrayColor = Color(red: 200/255, green: 200/255, blue: 200/255)

    
    var data: [T]
    
    var filteredData: [T] {
        if searchText.isEmpty {
            return self.data
        } else {
            return self.data.filter { $0.dropdownLabel.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init(selectedItem: Binding<T?>, data: [T]) {
        self.data = data
        self._selectedItem = selectedItem
        self._dropdownLabel = State(initialValue: selectedItem.wrappedValue?.dropdownLabel ?? "Select an Option")
    }
    
    var body: some View {
        let filteredItems = filteredData
        
        return ZStack(alignment: .top) {
            VStack {
                dropdownButton
                
                Spacer()
                    .frame(height: isExpanded ? 300 : 0)
            }
            
            if isExpanded {
                dropdownListView(filteredItems: filteredItems)
            }
        }
        .background(backgroundTapGesture)
        .onChange(of: selectedItem) { _, newValue in
            dropdownLabel = newValue?.dropdownLabel ?? "Select an Option"
        }
        .onAppear {
            dropdownLabel = selectedItem?.dropdownLabel ?? "Select an Option"
        }
    }
    
    private var dropdownButton: some View {
        Button(action: {
            withAnimation {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(dropdownLabel)
                    .lineLimit(1)
                    .font(.callout)
                    .foregroundStyle(Color.black)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(Color.purple)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(darkerGrayColor, lineWidth: 1)
            )
        }
    }

    private var backgroundTapGesture: some View {
        Group {
            if isExpanded {
                Color.black.opacity(0.001)
                    .onTapGesture {
                        withAnimation {
                            isExpanded = false
                        }
                    }
                    .ignoresSafeArea()
            }
        }
    }


    @ViewBuilder
    private func dropdownListView(filteredItems: [T]) -> some View {
        VStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if filteredItems.isEmpty {
                Text("No results found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredItems, id: \.id) { item in
                            VStack(alignment: .leading, spacing: 2) {
                                Text((item as? User)?.name ?? item.dropdownLabel)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                if let user = item as? User {
                                    Text(user.email)
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                dropdownLabel = item.dropdownLabel
                                selectedItem = item
                                withAnimation {
                                    isExpanded = false
                                }
                            }
                            .background(Color.white)

//                            Text(item.dropdownLabel)
//                                .font(.system(size:13))
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding()
//                                .contentShape(Rectangle())
//                                .onTapGesture {
//                                    dropdownLabel = item.dropdownLabel
//                                    selectedItem = item
//                                    withAnimation {
//                                        isExpanded = false
//                                    }
//                                }
//                                .background(Color.white)
                            Divider()
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 300)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
        .offset(y: 60)
        .transition(.opacity)
        .zIndex(999)
    }

}

