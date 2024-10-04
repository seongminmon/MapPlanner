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
    case info
    case success
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: Color(.toastError)
        case .warning: Color(.toastWarning)
        case .info: Color(.toastInfo)
        case .success: Color(.darkTheme)
        }
    }
    
    var iconImage: Image {
        switch self {
        case .error: Image.error
        case .warning: Image.warning
        case .info: Image.info
        case .success: Image.success
        }
    }
}
