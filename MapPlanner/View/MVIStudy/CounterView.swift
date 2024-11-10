//
//  CounterView.swift
//  MapPlanner
//
//  Created by 김성민 on 11/1/24.
//

import SwiftUI

struct CounterView: View {
    
    @StateObject private var viewModel = CounterViewModel()
    
    var body: some View {
        HStack {
            Button("-") {
                viewModel.process(intent: .minus)
            }
            Text("Count: \(viewModel.state.count)")
            Button("+") {
                viewModel.process(intent: .plus)
            }
        }
    }
}

final class CounterViewModel: ObservableObject {
    @Published private(set) var state = CounterState()
    
    struct CounterState {
        var count: Int = 0
    }
    
    enum CounterIntent {
        case plus
        case minus
    }
    
    func process(intent: CounterIntent) {
        switch intent {
        case .plus:
            state.count += 1
        case .minus:
            state.count -= 1
        }
    }
}
