//
//  ToastStyle.swift
//  MapPlanner
//
//  Created by 김성민 on 9/30/24.
//

import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case info
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: Color(.toastError)
        case .warning: Color(.toastWarning)
        case .info: Color(.toastInfo)
        case .success: Color(.toastSuccess)
        }
    }
    
    var iconImage: Image {
        switch self {
        case .info: Image.info
        case .warning: Image.warning
        case .success: Image.success
        case .error: Image.error
        }
    }
}
