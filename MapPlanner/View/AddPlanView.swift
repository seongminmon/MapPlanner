//
//  AddPlanView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import PhotosUI

struct AddPlanView: View {
    
    @State private var showActionSheet = false
    @State private var showPhotosPicker = false
    @State private var showCamera = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    
//    @State private var title = ""
//    @State private var contents = ""
    
    var body: some View {
        VStack {
            Button {
                showActionSheet.toggle()
            } label: {
                imageButton()
            }
            
//            Text("제목")
//                .bold()
//            TextField("일정 제목", text: $title)
        }
        .confirmationDialog("", isPresented: $showActionSheet) {
            Button("앨범") {
                showPhotosPicker.toggle()
            }
            Button("카메라") {
                // TODO: - 카메라 기능 구현
                showCamera.toggle()
            }
            Button("취소", role: .cancel) {}
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedPhoto)
        .alert("Camera", isPresented: $showCamera) {
            Text("Mimicking showing camera")
        }
        .task(id: selectedPhoto) {
            image = try? await selectedPhoto?.loadTransferable(type: Image.self)
        }
    }
    
    @ViewBuilder
    func imageButton() -> some View {
        if let image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(.primary))
                .background(Color(.secondary))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Image.camera
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(.primary))
                .background(Color(.secondary))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    AddPlanView()
}
