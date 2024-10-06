//
//  SettingView.swift
//  MapPlanner
//
//  Created by 김성민 on 10/6/24.
//

import SwiftUI
import MessageUI

struct SettingView: View {
    
    @State private var showMailView = false
    @State private var showMailSettingAlert = false
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                mailButton()
                PrivacyPolicyLink()
                versionView()
            }
            .padding()
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        // 메일 뷰
        .sheet(isPresented: $showMailView) {
            MailView()
        }
        // 메일 설정 Alert
        .alert("Mail 앱에서 사용자의 Email을 계정을 설정해 주세요.", isPresented: $showMailSettingAlert) {
            Button("설정") {
                guard let mailSettingsURL = URL(string: UIApplication.openSettingsURLString + "&&path=MAIL"),
                      UIApplication.shared.canOpenURL(mailSettingsURL) else { return }
                UIApplication.shared.open(mailSettingsURL, options: [:], completionHandler: nil)
            }
            Button("취소", role: .cancel) {}
        }
    }
    
    private func mailButton() -> some View {
        Button {
            if MFMailComposeViewController.canSendMail() {
                showMailView = true
            } else {
                showMailSettingAlert = true
            }
        } label: {
            HStack {
                Text("문의하기")
                    .asTextModifier(font: .regular15, color: .appPrimary)
                Spacer()
                Image.rightChevron
                    .foregroundStyle(.appSecondary)
            }
        }
    }
    
    private func PrivacyPolicyLink() -> some View {
        NavigationLink(destination: PrivacyPolicyView()) {
            HStack {
                Text("개인정보 처리방침")
                    .asTextModifier(font: .regular15, color: .appPrimary)
                Spacer()
                Image.rightChevron
                    .foregroundStyle(.appSecondary)
            }
        }
    }
    
    private func versionView() -> some View {
        HStack {
            Text("버전 정보")
            Spacer()
            Text(version)
        }
        .asTextModifier(font: .regular15, color: .appPrimary)
    }
}
