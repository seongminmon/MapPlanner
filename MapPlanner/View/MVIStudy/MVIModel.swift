//
//  MVIModel.swift
//  MapPlanner
//
//  Created by 김성민 on 10/31/24.
//

import Foundation

protocol MVIModelStateProtocol {
    var text: String { get }
}

protocol MVIModelActionProtocol: AnyObject {
    func parse(newValue: String)
}

final class MVIModel: ObservableObject, MVIModelStateProtocol {
    @Published var text: String = ""
}

extension MVIModel: MVIModelActionProtocol {
    func parse(newValue: String) {
        text = newValue
    }
}
