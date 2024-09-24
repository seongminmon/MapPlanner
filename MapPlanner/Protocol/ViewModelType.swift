//
//  ViewModelType.swift
//  MapPlanner
//
//  Created by 김성민 on 9/24/24.
//

import Foundation
import Combine

protocol ViewModelType: ObservableObject {
    associatedtype Input
    associatedtype Output
    
    var cancellables: Set<AnyCancellable> { get set }
    
    var input: Input { get set }
    var output: Output { get set }
    
    func transform()
}
