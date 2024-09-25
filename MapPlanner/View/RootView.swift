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
        .task {
            do {
                let result = try await NetworkManager.shared.callRequest("카페")
                print("응답 데이터: \(result)")
            } catch {
                print("에러 발생: \(error)")
            }
        }
    }
    
    private func planTabBar() -> some View {
        HStack(spacing: 20) {
            ForEach(TabInfo.allCases, id: \.self) { tab in
                Button {
                    viewModel.input.tabChangeButtonTap.send(tab)
                } label: {
                    Text(tab.rawValue)
                        .fontWeight(viewModel.output.selectedTab == tab ? .bold : .regular)
                        .padding(.bottom, 4)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .frame(height: viewModel.output.selectedTab == tab ? 2 : 1)
                        }
                        .foregroundColor(viewModel.output.selectedTab == tab ? Color(.appPrimary): Color(.appSecondary))
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
        TabView(selection: $viewModel.output.selectedTab) {
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
