//
//  ContentView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            MainView()
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
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
