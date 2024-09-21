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
    
    // 사진
    @State private var showImageActionSheet = false
    @State private var showPhotosPicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @State private var uiImage: UIImage?
    
    // 제목 *
    @State private var title = ""
    
    // 날짜 *
    @State var selectedDate: Date
    @State private var isTimeIncluded = false
    @State private var showDatePicker = false
    @State var datePickerDate: Date
    @State private var showTimePicker = false
    @State var datePickerTime: Date
    
    // 장소
    @State private var lat: Double?
    @State private var lng: Double?
    
    // 내용
    @State private var contents = ""
    
    // 유효성 검사 제목 / 날짜 필수
    var disabled: Bool {
        return title.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // 사진
            Button {
                showImageActionSheet.toggle()
            } label: {
                imageButton()
            }
            
            // 제목
            titleTextField()
            
            // 날짜
            Button {
                datePickerDate = selectedDate
                showDatePicker.toggle()
            } label: {
                Text(selectedDate.toString("yyyy.MM.dd (E)"))
                    .font(.title3)
                    .bold()
                Spacer()
                Image.rightChevron
                    .bold()
            }
            .foregroundStyle(Color(.appPrimary))
            
            // 시간
            Button {
                showTimePicker.toggle()
            } label: {
                if isTimeIncluded {
                    Text(selectedDate.toString("a hh:mm"))
                        .font(.title3)
                        .bold()
                    Button {
                        isTimeIncluded = false
                    } label: {
                        Image.xmark
                    }
                } else {
                    Text("종일")
                        .font(.title3)
                        .bold()
                }
                Spacer()
                Image.rightChevron
                    .bold()
            }
            .foregroundStyle(Color(.appPrimary))
            
            // 장소
            addLocationButton()
            
            // contents
            // TODO: - 여러 줄 입력
            TextField("내용", text: $contents)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        // 네비게이션
        .navigationTitle("일정 추가")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.leftChevron
                }
                .buttonStyle(PlainButtonStyle())
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: - Realm에 저장 + image파일 저장
                    let plan = Plan(title: title, date: selectedDate, lat: lat, lng: lng, contents: contents, photo: false)
                    if let uiImage {
                        ImageFileManager.shared.saveImageFile(image: uiImage, filename: "\(plan.id)")
                        plan.photo = true
                    }
                    $plans.append(plan)
                    dismiss()
                } label: {
                    Text("저장")
                }
                .foregroundStyle(Color(.appPrimary))
                .buttonStyle(PlainButtonStyle())
                .disabled(disabled)
            }
        }
        // PhotoPicker
        .confirmationDialog("", isPresented: $showImageActionSheet) {
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
        // DatePicker
        .sheet(isPresented: $showDatePicker) {
            datePickerSheetView()
        }
        // TimePicker
        .sheet(isPresented: $showTimePicker) {
            timePickerSheetView()
        }
        .padding()
//        .onAppear {
//            debugPrint(Realm.Configuration.defaultConfiguration.fileURL ?? "")
//        }
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
    
    func titleTextField() -> some View {
        VStack {
            Text("제목 *")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("일정 제목", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    func datePickerSheetView() -> some View {
        VStack(spacing: 20) {
            Spacer()
            DatePicker(
                "",
                selection: $datePickerDate,
                in: Date.startDate...Date.endDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
            // 저장 버튼
            Button {
                selectedDate = datePickerDate
                showDatePicker = false
            } label: {
                Text("저장")
                    .font(.system(size: 16))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(Color(.background))
                    .background(Color(.button))
                    .clipShape(.capsule)
                    .padding()
            }
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
    
    func timePickerSheetView() -> some View {
        VStack(spacing: 20) {
            Spacer()
            DatePicker(
                "",
                selection: $datePickerTime,
                displayedComponents: [.hourAndMinute]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
            // 저장 버튼
            Button {
                selectedDate = Calendar.current.date(
                    bySettingHour: Calendar.current.component(.hour, from: datePickerTime),
                    minute: Calendar.current.component(.minute, from: datePickerTime),
                    second: 0, of: selectedDate
                )!
                isTimeIncluded = true
                showTimePicker = false
            } label: {
                Text("저장")
                    .font(.system(size: 16))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(Color(.background))
                    .background(Color(.button))
                    .clipShape(.capsule)
                    .padding()
            }
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
    
    func addLocationButton() -> some View {
        VStack {
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
        }
    }
}

#Preview {
    AddPlanView(selectedDate: Date(), datePickerDate: Date(), datePickerTime: Date())
}
