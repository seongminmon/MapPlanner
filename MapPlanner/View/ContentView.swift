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
                        Button {
                            print("search")
                        } label: {
                            Image.search
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            print("profile")
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
