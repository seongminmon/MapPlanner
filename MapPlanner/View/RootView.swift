//
//  RootView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        planTabView()
    }
    
    private func planTabView() -> some View {
        TabView(selection: $viewModel.output.selectedTab) {
            NavigationStack {
                CalendarView()
                // 네비게이션 바
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text("Map Planner")
                                .font(.boldTitle)
                                .foregroundStyle(Color(.darkTheme))
                        }
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            NavigationLink {
                                SearchView()
                            } label: {
                                Image.search
                            }
                            .foregroundStyle(Color(.appPrimary))
                            
                            NavigationLink {
                                SettingView()
                            } label: {
                                Image.setting
                            }
                            .foregroundStyle(Color(.appPrimary))
                        }
                    }
            }
            .tabItem {
                Image.calendar
                Text(TabInfo.calendar.rawValue)
            }
            .tag(TabInfo.calendar)
            
            NavigationStack {
                MapView()
            }
            .tabItem {
                Image.map
                Text(TabInfo.map.rawValue)
            }
            .tag(TabInfo.map)
            
            NavigationStack {
                TimeLineView()
                // 네비게이션 바
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text("Map Planner")
                                .font(.boldTitle)
                                .foregroundStyle(Color(.darkTheme))
                        }
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            NavigationLink {
                                SearchView()
                            } label: {
                                Image.search
                            }
                            .foregroundStyle(Color(.appPrimary))
                            
                            NavigationLink {
                                SettingView()
                            } label: {
                                Image.setting
                            }
                            .foregroundStyle(Color(.appPrimary))
                        }
                    }
            }
            .tabItem {
                Image.list
                Text(TabInfo.timeline.rawValue)
            }
            .tag(TabInfo.timeline)
        }
        .tint(Color(.darkTheme))
    }
}
