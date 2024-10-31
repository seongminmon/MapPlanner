//
//  MVIView.swift
//  MapPlanner
//
//  Created by 김성민 on 10/31/24.
//

import SwiftUI
import Combine

struct MVIView: View {
    
    @StateObject private var container: MVIContainer<MVIIntent, MVIModelStateProtocol>
    
    var body: some View {
        VStack {
            Text(container.model.text)
            Button("Random!!!") {
                container.intent.performAction(.randomButtonTap)
            }
        }
        .padding()
        .onAppear {
            container.intent.performAction(.viewOnAppear)
        }
    }
}

extension MVIView {
    static func build() -> some View {
        let model = MVIModel()
        let intent = MVIIntent(model: model)
        let container = MVIContainer(
            intent: intent,
            model: model as MVIModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        return MVIView(container: container)
    }
}
