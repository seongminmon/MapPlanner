//
//  AddPlanView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import PhotosUI

struct AddPlanView: View {
    
    // TODO: - 사진 ✅ / 제목 / 날짜 / 장소 / 내용 정하기
    // TODO: - DatePicker 커스텀
    
    @Environment(\.realm) var realm
    @Environment(\.dismiss) private var dismiss
    
    @State private var showActionSheet = false
    @State private var showPhotosPicker = false
    @State private var showCamera = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    
    @State private var title = ""
    @State private var date: Date = Date()
//    @State private var contents = ""
    
    var plan: Plan? {
        return Plan(title: title, date: date)
    }
    
    var disabled: Bool {
        return plan == nil
    }
    
    var body: some View {
        VStack {
            Button {
                showActionSheet.toggle()
            } label: {
                imageButton()
            }
            Text("제목")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("일정 제목", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("날짜")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            DatePicker("날짜", selection: $date)
            
            Text("장소")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            NavigationLink {
                LocationSearchView()
            } label: {
                HStack {
                    Image.location
                    Text("장소 추가")
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(Color(.background))
            .background(Color(.button))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
        }
        .navigationTitle("일정 추가")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.back
                }
                .buttonStyle(PlainButtonStyle())
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: - 필수값 채워졌는지 유효성 체크
                    // TODO: - Realm에 저장 + 첫 화면으로 돌아가기
                } label: {
                    Text("저장")
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(disabled)
            }
        }
        .confirmationDialog("", isPresented: $showActionSheet) {
            Button("앨범") {
                showPhotosPicker.toggle()
            }
//            Button("카메라") {
//                showCamera.toggle()
//            }
            Button("취소", role: .cancel) {}
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedPhoto)
        .alert("Camera", isPresented: $showCamera) {
            Text("Mimicking showing camera")
        }
        .task(id: selectedPhoto) {
            image = try? await selectedPhoto?.loadTransferable(type: Image.self)
        }
        .padding()
    }
    
    @ViewBuilder
    func imageButton() -> some View {
        if let image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(.appPrimary))
                .background(Color(.appSecondary))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Image.camera
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(.appPrimary))
                .background(Color(.appSecondary))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    AddPlanView()
}
