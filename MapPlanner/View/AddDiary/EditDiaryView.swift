//
//  EditDiaryView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI
import PhotosUI

struct EditDiaryView: View {
    
    // TODO: - 작성된 내용이 있을때 dismiss시 확인 Alert 띄우기
    
    // MARK: - diary == nil ? 추가 : 수정
    var diary: Diary?
    
    @StateObject private var diaryManager = DiaryManager()
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
    
    init(diary: Diary?, selectedDate: Date?) {
        self._selectedDate = State(initialValue: selectedDate ?? Date())
        
        self.diary = diary
        guard let diary else { return }
        
        // 초기값 설정
        self._uiImage = State(initialValue: ImageFileManager.shared.loadImageFile(filename: "\(diary.id)"))
        self._title = State(initialValue: diary.title)
        self._selectedDate = State(initialValue: diary.date)
        self._isTimeIncluded = State(initialValue: diary.isTimeIncluded)
        self._contents = State(initialValue: diary.contents)
        self._location = State(initialValue: diary.toLocation())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 250) {
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
            .padding(.bottom, 80)
        }
        .scrollIndicators(.never)
        // 네비게이션
        .navigationTitle(diary == nil ? "기록 추가" : "수정하기")
        .navigationBarTitleDisplayMode(.inline)
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
                    diary == nil ? addDiary() : updateDiary()
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
                    ImageFileManager.shared.deleteImageFile(filename: "\(diary?.id ?? "")")
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
        .scrollDismissesKeyboard(.immediately)
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
                        .frame(width: geometry.size.width, height: 250)
                        .clipped()
                } else {
                    Image.camera
                        .resizable()
                        .frame(width: 50, height: 40)
                        .frame(width: geometry.size.width, height: 250)
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
            TextField("기록 제목", text: $title)
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
            } else {
                Text("시간 선택")
                    .font(.bold18)
            }
            Spacer()
            if isTimeIncluded {
                Button {
                    isTimeIncluded = false
                } label: {
                    Image.xmark
                }
            } else {
                Image.rightChevron
                    .bold()
            }
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
                ) ?? Date()
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
                } else {
                    Image.rightChevron
                        .bold()
                }
            }
        }
        .foregroundStyle(Color(.appPrimary))
    }
    
    private func contentsTextField() -> some View {
        VStack {
            Text("내용")
                .font(.bold15)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextEditor(text: $contents)
                .customStyleEditor(placeholder: "내용을 입력해주세요", userInput: $contents)
                .frame(height: 200)
        }
    }
    
    private func addDiary() {
        let diary = RealmDiary(
            title: title,
            date: selectedDate,
            isTimeIncluded: isTimeIncluded,
            contents: contents,
            locationID: location?.id ?? "",
            placeName: location?.placeName ?? "",
            addressName: location?.addressName ?? "",
            lat: location?.lat,
            lng: location?.lng,
            category: location?.category ?? ""
        )
        diaryManager.addDiary(diary: diary, image: uiImage)
    }
    
    private func updateDiary() {
        guard let diary else { return }
        
        let newDiary = Diary(
            id: diary.id,
            savedDate: Date(),
            title: title,
            date: selectedDate,
            isTimeIncluded: isTimeIncluded,
            contents: contents,
            locationID: location?.id ?? "",
            placeName: location?.placeName ?? "",
            addressName: location?.addressName ?? "",
            lat: location?.lat,
            lng: location?.lng,
            category: location?.category ?? ""
        )
        diaryManager.updateDiary(diaryID: diary.id, newDiary: newDiary, image: uiImage)
    }
}
