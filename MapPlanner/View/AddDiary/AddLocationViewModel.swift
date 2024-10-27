//
//  AddLocationViewModel.swift
//  MapPlanner
//
//  Created by 김성민 on 10/5/24.
//

import Foundation
import Combine

final class AddLocationViewModel: ViewModelType {
    
    private var response: LocalResponse?
    private var recentQuery = ""
    private var page = 1
    private var isEnd = false
    
    struct Input {
        let searchButtonTap = PassthroughSubject<Void, Never>()
        let onAppearItem = PassthroughSubject<Location, Never>()
    }
    
    struct Output {
        var locationList: [Location] = []
        var query = ""
        var isLoading = false
    }
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
    
    func transform() {
        input.searchButtonTap
            .sink { [weak self] _ in
                self?.search()
            }
            .store(in: &cancellables)
        
        input.onAppearItem
            .sink { [weak self] item in
                self?.paginationIfNeeded(item: item)
            }
            .store(in: &cancellables)
    }
    
    private func search() {
        guard !output.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                output.query != recentQuery else { return }
        
        recentQuery = output.query
        page = 1
        isEnd = false
        response = nil
        output.locationList.removeAll()
        output.isLoading = true
        fetchData(query: output.query, page: page)
    }
    
    private func paginationIfNeeded(item: Location) {
        guard !isEnd, item == output.locationList.last else { return }
        
        page += 1
        output.isLoading = true
        fetchData(query: recentQuery, page: page)
    }
    
    private func fetchData(query: String, page: Int) {
        NetworkManager.shared.callRequest(.local(query: query, page: page), LocalResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self?.output.isLoading = false
                }
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                self?.response = result
                self?.isEnd = result.meta.is_end
                let newLocationList = result.documents.map { $0.toLocation() }
                DispatchQueue.main.async {
                    if page == 1 {
                        self?.output.locationList = newLocationList
                    } else {
                        self?.output.locationList.append(contentsOf: newLocationList)
                    }
                }
            })
            .store(in: &cancellables)
    }
}
