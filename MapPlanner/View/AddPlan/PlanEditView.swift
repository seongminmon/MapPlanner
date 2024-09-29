//
//  PlanEditView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI
import PhotosUI

struct PlanEditView: View {
    
    // TODO: - 키보드 핸들링 - 활성화 시 높이 조절
    
    // MARK: - plan == nil ? 추가 : 수정
    var plan: PlanOutput?
    
    @StateObject private var planStore = PlanStore()
    @Environment(\.dismiss) private var dismiss
    
    // 사진
    @State private var showImageActionSheet = false
    @State private var showPhotosPicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImage: UIImage?
    
    // 제목 *
    @State private var title = ""
    
    // 날짜 *
    @State var selectedDate: Date
    @State private var showDatePicker = false
    @State private var datePickerDate: Date = Date()
    @State private var isTimeIncluded = false
    @State private var showTimePicker = false
    @State private var datePickerTime: Date = Date()
    
    // 내용
    @State private var contents = ""
    
    // 장소
    @State private var location: Location?
    
    // 유효성 검사: 제목 + 날짜 필수
    private var disabled: Bool {
        return title.isEmpty
    }
    
    init(plan: PlanOutput?, selectedDate: Date?) {
        self._selectedDate = State(initialValue: selectedDate ?? Date())
        
        self.plan = plan
        guard let plan else { return }
        
        // 초기값 설정
        self._uiImage = State(initialValue: ImageFileManager.shared.loadImageFile(filename: "\(plan.id)"))
        self._title = State(initialValue: plan.title)
        self._selectedDate = State(initialValue: plan.date)
        self._isTimeIncluded = State(initialValue: plan.isTimeIncluded)
        self._contents = State(initialValue: plan.contents)
        self._location = State(initialValue: plan.toLocation())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 300) {
                imageButton()
                VStack(spacing: 20) {
                    titleTextField()
                    contentsTextField()
                    showDatePickerButton()
                    showTimePickerButton()
                    addLocationButton()
                }
                .padding()
            }
        }
        .scrollIndicators(.never)
        // 네비게이션
        .navigationTitle(plan == nil ? "일정 추가" : "수정하기")
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
                    plan == nil ? addPlan() : updatePlan()
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
            if uiImage != nil {
                Button("삭제", role: .destructive) {
                    selectedPhoto = nil
                    uiImage = nil
                }
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
        // 키보드 내리기
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    // MARK: - View Components
    
    private func imageButton() -> some View {
        GeometryReader { geometry in
            Button {
                showImageActionSheet.toggle()
            } label: {
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: 300)
                        .clipped()
                } else {
                    Image.camera
                        .resizable()
                        .frame(width: 50, height: 40)
                        .frame(width: geometry.size.width, height: 300)
                        .foregroundStyle(Color(.appPrimary))
                        .background(Color(.appSecondary))
                }
            }
        }
    }
    
    private func titleTextField() -> some View {
        VStack {
            Text("제목 *")
                .font(.bold15)
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
            Text(selectedDate.toString(DateFormat.untilWeekDay))
                .font(.bold18)
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
                    .font(.bold18)
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
                Text(selectedDate.toString(DateFormat.time))
                    .font(.bold18)
                Button {
                    isTimeIncluded = false
                } label: {
                    Image.xmark
                }
            } else {
                Text("시간 +")
                    .font(.bold18)
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
        NavigationLink {
            AddLocationView(selectedLocation: $location)
        } label: {
            HStack {
                if let location {
                    VStack(alignment: .leading) {
                        Text(location.placeName)
                            .font(.bold18)
                            .foregroundStyle(Color(.appPrimary))
                        Text(location.addressName)
                            .font(.regular15)
                            .foregroundStyle(Color(.appSecondary))
                    }
                } else {
                    Text("장소 선택")
                        .font(.bold18)
                }
                Spacer()
                if location != nil {
                    Button {
                        self.location = nil
                    } label: {
                        Image.xmark
                    }
                }
                Image.rightChevron
                    .bold()
            }
        }
        .foregroundStyle(Color(.appPrimary))
    }
    
    private func contentsTextField() -> some View {
        VStack {
            Text("내용")
                .font(.bold15)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("내용을 입력해주세요", text: $contents, axis: .vertical)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private func addPlan() {
        let plan = Plan(
            title: title,
            date: selectedDate,
            isTimeIncluded: isTimeIncluded,
            contents: contents,
            locationID: location?.id ?? "",
            placeName: location?.placeName ?? "",
            addressName: location?.addressName ?? "",
            lat: location?.lat,
            lng: location?.lng
        )
        planStore.addPlan(plan: plan, image: uiImage)
    }
    
    private func updatePlan() {
        guard let plan else { return }
        
        let newPlan = PlanOutput(
            id: plan.id,
            savedDate: Date(),
            title: title,
            date: selectedDate,
            isTimeIncluded: isTimeIncluded,
            contents: contents,
            locationID: location?.id ?? "",
            placeName: location?.placeName ?? "",
            addressName: location?.addressName ?? "",
            lat: location?.lat,
            lng: location?.lng
        )
        planStore.updatePlan(planID: plan.id, newPlan: newPlan, image: uiImage)
    }
}
