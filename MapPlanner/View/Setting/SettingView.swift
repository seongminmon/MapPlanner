//
//  SettingView.swift
//  MapPlanner
//
//  Created by 김성민 on 10/6/24.
//

import SwiftUI

struct SettingView: View {
    
    @StateObject private var container: MVIContainer<SettingIntent, SettingModelStateProtocol>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                mailButton()
                privacyPolicyLink()
                versionView()
            }
            .padding()
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        // 메일 뷰
        .sheet(isPresented: Binding(
            get: { container.model.showMailView },
            set: { _ in container.intent.performAction(.closeMailView) }
        )) {
            MailView()
        }
        // 메일 설정 Alert
        .alert("Mail 앱에서 사용자의 Email을 계정을 설정해 주세요.", isPresented: Binding(
            get: { container.model.showMailSettingAlert },
            set: { _ in container.intent.performAction(.closeMailSettingAlert) }
        )) {
            Button("설정") {
                container.intent.performAction(.mailSettingButtonTap)
            }
            Button("취소", role: .cancel) {}
        }
    }
    
    private func mailButton() -> some View {
        Button {
            container.intent.performAction(.mailButtonTap)
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
    
    private func privacyPolicyLink() -> some View {
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
            Text(container.model.version)
        }
        .asTextModifier(font: .regular15, color: .appPrimary)
    }
}

extension SettingView {
    static func build() -> some View {
        let model = SettingModel()
        let intent = SettingIntent(model: model)
        let container = MVIContainer(
            intent: intent,
            model: model as SettingModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        return SettingView(container: container)
    }
}
