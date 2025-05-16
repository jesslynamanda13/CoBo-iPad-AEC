//
//  BookingPurposeDropdownComponent.swift
//  CoBo
//
//  Created by Evan Lokajaya on 04/04/25.
//

import SwiftUI

struct BookingPurposeDropdownComponent: View {
    @State private var isExpanded = false
    @State private var dropdownLabel: String
    @State private var customOtherText: String = ""
    @Binding private var selectedItem: BookingPurpose?

    let lightGrayColor = Color(red: 200/255, green: 200/255, blue: 200/255)
    
    var data: [BookingPurpose] = BookingPurpose.allValues
    
    init(selectedItem: Binding<BookingPurpose?>) {
        self._selectedItem = selectedItem
        if case .others(let value) = selectedItem.wrappedValue {
            self._dropdownLabel = State(initialValue: value.isEmpty ? "Others" : value)
            self._customOtherText = State(initialValue: value)
        } else {
            self._dropdownLabel = State(initialValue: selectedItem.wrappedValue?.displayName ?? "Select an Option")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if case .others = selectedItem {
                    TextField("Enter custom purpose", text: $customOtherText)
                        .font(.callout)
                        .onChange(of: customOtherText) { newValue in
                            selectedItem = .others(newValue)
                            dropdownLabel = "" // Clear label while typing
                        }
                } else {
                    Text(dropdownLabel)
                        .lineLimit(1)
                        .font(.callout)
                        .foregroundStyle(Color.black)
                }

                Spacer()

                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Color.purple)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.clear)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lightGrayColor, lineWidth: 1)
            )

            if isExpanded {
                VStack(spacing: 0) {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(data, id: \.displayName) { item in
                                Text(item.displayName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .font(.system(size: 13))
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation {
                                            isExpanded = false
                                        }
                                        if case .others = item {
                                            selectedItem = .others("")
                                            dropdownLabel = ""
                                            customOtherText = ""
                                        } else {
                                            selectedItem = item
                                            dropdownLabel = item.displayName
                                        }
                                    }
                                    .background(Color.white)
                                Divider()
                            }
                        }
                    }
                }
                .frame(maxHeight: 200)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .background(
            isExpanded ?
                Color.black.opacity(0.001)
                    .onTapGesture {
                        withAnimation {
                            isExpanded = false
                        }
                    }
                    .ignoresSafeArea()
                : nil
        )
    }
}

