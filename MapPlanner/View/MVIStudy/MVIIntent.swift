//
//  MVIIntent.swift
//  MapPlanner
//
//  Created by 김성민 on 10/31/24.
//

import Foundation

final class MVIIntent {
    
    enum Action {
        case viewOnAppear
        case randomButtonTap
    }
    
    private weak var model: MVIModelActionProtocol?
    
    init(model: MVIModelActionProtocol) {
        self.model = model
    }

    func performAction(_ action: Action) {
        switch action {
        case .viewOnAppear:
            getRandomNumber()
            
        case .randomButtonTap:
            getRandomNumber()
        }
    }
    
    private func getRandomNumber() {
        let number = Int.random(in: 0..<100)
        let randomText = "Random number: \(String(number))"
        model?.parse(newValue: randomText)
    }
}
