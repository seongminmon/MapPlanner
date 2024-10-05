//
//  AddLocationViewModel.swift
//  MapPlanner
//
//  Created by 김성민 on 10/5/24.
//

import Combine

final class AddLocationViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        var response: LocalResponse?
        var locationList: [Location] = []
        var recentQuery = ""
        var query = ""
        var currentPage = 1
        var isLoading = false
        var isLastPage = false
    }
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
    
    func transform() {
        
    }
}
