//
//  ContentView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var path = NavigationPath()
    @State private var clickedDate: Date?
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                MainView(clickedDate: $clickedDate)
                addPlanButton()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("User's")
                        .font(.boldTitle)
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink {
                        SearchView()
                    } label: {
                        Image.search
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Image.person
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    func addPlanButton() -> some View {
        NavigationLink {
            AddPlanView(selectedDate: clickedDate ?? Date())
        } label: {
            Image.plus
                .foregroundStyle(Color(.background))
                .padding()
                .frame(width: 50, height: 50)
                .background(Color(.appPrimary))
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding()
    }
}

#Preview {
    ContentView()
}
