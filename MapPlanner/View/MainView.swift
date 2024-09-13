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
        HStack(spacing: 20) {
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
                        .foregroundColor(selectedTab == tab ? Color(.primary): Color(.secondary))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color(.secondary))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
        .padding()
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
