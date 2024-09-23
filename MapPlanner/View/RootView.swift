//
//  RootView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI

struct RootView: View {
    
    private enum TabInfo : String, CaseIterable {
        case calendar = "캘린더"
        case map = "지도"
        case timeline = "타임라인"
    }
    
    @State private var selectedTab: TabInfo = .calendar
    
    var body: some View {
        NavigationView {
            VStack {
                planTabBar()
                planTabView()
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
                    .foregroundStyle(Color(.appPrimary))
                    
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Image.person
                    }
                    .foregroundStyle(Color(.appPrimary))
                }
            }
        }
    }
    
    private func planTabBar() -> some View {
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
                        .foregroundColor(selectedTab == tab ? Color(.appPrimary): Color(.appSecondary))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color(.appSecondary))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    private func planTabView() -> some View {
        TabView(selection: $selectedTab) {
            CalendarView()
                .tag(TabInfo.calendar)
            MapView()
                .tag(TabInfo.map)
            TimeLineView()
                .tag(TabInfo.timeline)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    RootView()
}
