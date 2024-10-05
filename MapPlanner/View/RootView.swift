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
        diaryTabView()
    }
    
    private func diaryTabView() -> some View {
        TabView(selection: $viewModel.output.selectedTab) {
            NavigationStack {
                CalendarView()
                    .asRootNavigationBar()
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
                    .asRootNavigationBar()
            }
            .tabItem {
                Image.list
                Text(TabInfo.timeline.rawValue)
            }
            .tag(TabInfo.timeline)
        }
        .tint(.darkTheme)
    }
}
