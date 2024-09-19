//
//  AddPlanView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI
import PhotosUI
import RealmSwift

struct AddPlanView: View {
    
    // TODO: - 사진 ✅ / 제목 ✅ / 날짜 ✅ / 장소 / 내용 ✅
    // TODO: - DatePicker 커스텀
    
    @ObservedResults(Plan.self) var plans
    @Environment(\.dismiss) private var dismiss
    
    @State private var showActionSheet = false
    @State private var showPhotosPicker = false
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @State private var uiImage: UIImage?
    
    @State private var title = ""
    @State private var date = Date()
    @State private var lat: Double?
    @State private var lng: Double?
    @State private var contents = ""
    
    // 유효성 검사 제목 / 날짜 필수
    var disabled: Bool {
        return title.isEmpty
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
            DatePicker("", selection: $date)
            
            Text("장소")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            NavigationLink {
                AddLocationView()
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
            
            TextField("내용", text: $contents)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    // TODO: - Realm에 저장 + image파일 저장
                    let plan = Plan(title: title, date: date, lat: lat, lng: lng, contents: contents, photo: false)
                    if let uiImage {
                        ImageFileManager.shared.saveImageFile(image: uiImage, filename: "\(plan.id)")
                        plan.photo = true
                    }
                    $plans.append(plan)
                    
                    dismiss()
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
            Button("취소", role: .cancel) {}
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedPhoto)
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.uiImage = uiImage
                image = Image(uiImage: uiImage)
            }
        }
        .onAppear {
            debugPrint(Realm.Configuration.defaultConfiguration.fileURL ?? "")
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
