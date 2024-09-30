//
//  Toast.swift
//  MapPlanner
//
//  Created by 김성민 on 9/30/24.
//

import Foundation

struct Toast: Equatable {
    var type: ToastStyle
    var title: String
    var message: String
    var duration: Double = 3
}
