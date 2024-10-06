//
//  RootViewModel.swift
//  MapPlanner
//
//  Created by 김성민 on 9/24/24.
//

import Combine

enum TabInfo : String, CaseIterable {
    case calendar = "캘린더"
    case map = "지도"
    case timeline = "타임라인"
    case setting = "설정"
}

final class RootViewModel: ViewModelType {
    
    struct Input {
        let tabChangeButtonTap = PassthroughSubject<TabInfo, Never>()
    }
    
    struct Output {
        var selectedTab: TabInfo = .calendar
    }
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
    
    func transform() {
        input.tabChangeButtonTap
            .sink { [weak self] value in
                self?.output.selectedTab = value
            }
            .store(in: &cancellables)
    }
}
