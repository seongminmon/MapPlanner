//
//  SettingModel.swift
//  MapPlanner
//
//  Created by 김성민 on 11/1/24.
//

import Foundation

protocol SettingModelStateProtocol {
    var showMailView: Bool { get }
    var showMailSettingAlert: Bool { get }
    var version: String { get }
}

protocol SettingModelActionProtocol: AnyObject {
    func setShowMailView(newValue: Bool)
    func setShowMailSettingAlert(newValue: Bool)
}

final class SettingModel: ObservableObject, SettingModelStateProtocol {
    @Published var showMailView = false
    @Published var showMailSettingAlert = false
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}

extension SettingModel: SettingModelActionProtocol {
    func setShowMailView(newValue: Bool) {
        showMailView = newValue
    }
    
    func setShowMailSettingAlert(newValue: Bool) {
        showMailSettingAlert = newValue
    }
}
