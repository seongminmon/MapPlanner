//
//  MainView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI

enum TabInfo : String, CaseIterable {
    case calendar = "캘린더"
    case map = "지도"
    case timeline = "타임라인"
}

struct CustomTabBar: View {
    
    @Binding var selectedTab: TabInfo
    
    var body: some View {
        HStack {
            ForEach(TabInfo.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    Text(tab.rawValue)
                        .fontWeight(selectedTab == tab ? .bold : .regular)
                        .padding(.bottom, 4)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .frame(height: selectedTab == tab ? 2 : 1)
                        }
                        .foregroundColor(selectedTab == tab ? .primary: .secondary)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CustomTabView: View {
    
    @Binding var selectedTab: TabInfo
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HorizonCalendarView()
                .tag(TabInfo.calendar)
            
            MapView()
                .tag(TabInfo.map)
            
            Text("타임라인 View")
                .tag(TabInfo.timeline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.orange)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

struct MainView: View {
    
    @State private var selectedTab: TabInfo = .calendar
    
    var body: some View {
        VStack {
            CustomTabBar(selectedTab: $selectedTab)
            CustomTabView(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    MainView()
}
