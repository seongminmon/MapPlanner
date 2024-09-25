//
//  PlanEditView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI
import PhotosUI
import RealmSwift

struct PlanEditView: View {
    
    var plan: Plan
    
    @ObservedResults(Plan.self) var plans
    @Environment(\.dismiss) private var dismiss
    
    // 사진
    @State private var showImageActionSheet = false
    @State private var showPhotosPicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImage: UIImage?
    
    // 제목 *
    @State private var title = ""
    
    // 날짜 *
    @State var selectedDate: Date = Date()
    @State private var showDatePicker = false
    @State private var datePickerDate: Date = Date()
    @State private var isTimeIncluded = false
    @State private var showTimePicker = false
    @State private var datePickerTime: Date = Date()
    
    // 내용
    @State private var contents = ""
    
    // 장소
    @State private var locationName = ""
    @State private var addressName = ""
    @State private var lat: Double?
    @State private var lng: Double?
    
    // 유효성 검사: 제목 + 날짜 필수
    private var disabled: Bool {
        return title.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 사진
                imageButton()
                // 제목
                titleTextField()
                // 날짜
                showDatePickerButton()
                // 시간
                showTimePickerButton()
                // 장소
                addLocationButton()
                // 내용
                contentsTextField()
                Spacer()
            }
        }
        .scrollIndicators(.never)
        // 네비게이션
        .navigationTitle("수정하기")
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
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Realm + image파일 업데이트
                    updatePlan()
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
        // 키보드 내리기
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            hideKeyboard()
        }
        // 초기값 적용
        .onAppear {
            title = plan.title
            selectedDate = plan.date
            isTimeIncluded = plan.isTimeIncluded
            contents = plan.contents
            locationName = plan.locationName
            addressName = plan.addressName
            lat = plan.lat
            lng = plan.lng
            if let storedImage = ImageFileManager.shared.loadImageFile(filename: "\(plan.id)") {
                uiImage = storedImage
            }
        }
    }
    
    // MARK: - View Components
    
    private func imageButton() -> some View {
        Button {
            showImageActionSheet.toggle()
        } label: {
            if let uiImage {
                Image(uiImage: uiImage)
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
    
    private func titleTextField() -> some View {
        VStack {
            Text("제목 *")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("일정 제목", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private func showDatePickerButton() -> some View {
        Button {
            datePickerDate = selectedDate
            showDatePicker.toggle()
        } label: {
            Text(selectedDate.toString("yyyy.MM.dd (E)"))
                .font(.bold20)
            Spacer()
            Image.rightChevron
                .bold()
        }
        .foregroundStyle(Color(.appPrimary))
    }
    
    private func datePickerSheetView() -> some View {
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
                    .font(.bold15)
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
    
    private func showTimePickerButton() -> some View {
        Button {
            showTimePicker.toggle()
        } label: {
            if isTimeIncluded {
                Text(selectedDate.toString("a hh:mm"))
                    .font(.bold20)
                Button {
                    isTimeIncluded = false
                } label: {
                    Image.xmark
                }
            } else {
                Text("시간 +")
                    .font(.bold20)
            }
            Spacer()
            Image.rightChevron
                .bold()
        }
        .foregroundStyle(Color(.appPrimary))
    }
    
    private func timePickerSheetView() -> some View {
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
                    .font(.bold15)
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
    
    private func addLocationButton() -> some View {
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
    
    private func contentsTextField() -> some View {
        VStack {
            Text("내용")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("내용을 입력해주세요", text: $contents, axis: .vertical)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private func updatePlan() {
        // 이미지 덮어쓰기
        if let uiImage {
            ImageFileManager.shared.saveImageFile(image: uiImage, filename: "\(plan.id)")
        } else {
            ImageFileManager.shared.deleteImageFile(filename: "\(plan.id)")
        }
        
        do {
            let realm = try Realm()
            guard let target = realm.object(ofType: Plan.self, forPrimaryKey: plan.id) else { return }
            try realm.write {
                target.savedDate = Date()
                target.title = title
                target.date = selectedDate
                target.isTimeIncluded = isTimeIncluded
                target.contents = contents
                target.locationName = locationName
                target.addressName = addressName
                target.lat = lat
                target.lng = lng
            }
            print("Realm 업데이트 성공")
        } catch {
            print("Realm 업데이트 실패: \(error)")
        }
    }
}
