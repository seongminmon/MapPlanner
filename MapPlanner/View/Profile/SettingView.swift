//
//  SettingView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI

struct SettingView: View {
    
    // TODO: -
    // 개인 정보 처리 방침
    // 오픈 소스 라이센스
    // 버전 정보
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Text("개인 정보 처리 방침")
            Text("오픈 소스 라이센스")
            Text("버전 정보")
        }
        // 네비게이션 바
        .navigationTitle("설정")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.leftChevron
                }
                .foregroundStyle(Color(.appPrimary))
            }
        }
    }
}
