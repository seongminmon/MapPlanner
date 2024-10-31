//
//  MVIContainer.swift
//  MapPlanner
//
//  Created by 김성민 on 10/31/24.
//

import Combine
import Foundation

final class MVIContainer<Intent, Model>: ObservableObject {
    
    let intent: Intent
    let model: Model
    
    private var cancellable = Set<AnyCancellable>()
    
    init(intent: Intent, model: Model, modelChangePublisher: ObjectWillChangePublisher) {
        self.intent = intent
        self.model = model
        
        // 모델 변경을 감지해주는 녀석 (아마도)
        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellable)
    }
}
