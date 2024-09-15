//
//  ContentView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                MainView()
                NavigationLink {
                    AddPlanView()
                } label: {
                    // TODO: - plus 키우기
                    Image.plus
                        .foregroundStyle(Color(.background))
                        .padding()
                        .frame(width: 60, height: 60)
                        .background(Color(.appPrimary))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("User's")
                        .font(.title)
                        .bold()
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
}

#Preview {
    ContentView()
}
