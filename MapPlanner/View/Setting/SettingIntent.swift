//
//  SettingIntent.swift
//  MapPlanner
//
//  Created by 김성민 on 11/1/24.
//

import Foundation
import MessageUI

final class SettingIntent {
    
    enum Action {
        case mailButtonTap
        case mailSettingButtonTap
        case closeMailView
        case closeMailSettingAlert
    }
    
    private weak var model: SettingModelActionProtocol?
    
    init(model: SettingModelActionProtocol) {
        self.model = model
    }
    
    func performAction(_ action: Action) {
        switch action {
        case .mailButtonTap:
            print("메일 버튼 탭")
            if MFMailComposeViewController.canSendMail() {
                model?.setShowMailView(newValue: true)
            } else {
                model?.setShowMailSettingAlert(newValue: true)
            }
        case .mailSettingButtonTap:
            print("메일 세팅 버튼 탭")
            guard let mailSettingsURL = URL(string: UIApplication.openSettingsURLString + "&&path=MAIL"),
                  UIApplication.shared.canOpenURL(mailSettingsURL) else { return }
            UIApplication.shared.open(mailSettingsURL, options: [:], completionHandler: nil)
        case .closeMailView:
            print("메일뷰 닫기")
            model?.setShowMailView(newValue: false)
        case .closeMailSettingAlert:
            // 왜 2번 찍히지?
            print("메일 세팅 얼럿 닫기")
            model?.setShowMailSettingAlert(newValue: false)
        }
    }
}
