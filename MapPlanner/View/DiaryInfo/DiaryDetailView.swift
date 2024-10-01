//
//  DiaryDetailView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/22/24.
//

import SwiftUI
import RealmSwift

struct DiaryDetailView: View {
    
    // TODO: - 지도에서 위치 보기
    
    var diary: Diary
    @StateObject private var diaryManager = DiaryManager()
    
    @Environment(\.dismiss) private var dismiss
    @State private var showActionSheet = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 350) {
                    imageView()
                    descriptionView()
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            // 네비게이션 바
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image.xmark
                    }
                    .foregroundStyle(Color(.white))
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showActionSheet.toggle()
                    } label: {
                        Image.ellipsis
                    }
                    .foregroundStyle(Color(.white))
                }
            }
            // Action Sheet
            .confirmationDialog("", isPresented: $showActionSheet) {
                NavigationLink {
                    EditDiaryView(diary: diary, selectedDate: nil)
                } label: {
                    Text("편집")
                }
                .foregroundStyle(Color(.appPrimary))
                Button("삭제", role: .destructive) {
                    showDeleteAlert.toggle()
                }
                Button("취소", role: .cancel) {}
            }
            // Alert
            .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
                Button("삭제", role: .destructive) {
                    diaryManager.deleteDiary(diaryID: diary.id)
                }
                Button("취소", role: .cancel) {}
            }
        }
    }
    
    @ViewBuilder
    private func imageView() -> some View {
        if let image = ImageFileManager.shared.loadImageFile(filename: "\(diary.id)") {
            GeometryReader { geometry in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 350)
                    .clipped()
            }
        } else {
            GeometryReader { geometry in
                Image.calendar
                    .resizable()
                    .frame(width: 50, height: 50)
                    .frame(width: geometry.size.width, height: 350)
                    .foregroundStyle(Color(.appPrimary))
                    .background(Color(.appSecondary))
            }
        }
    }
    
    // TODO: - 디자인 변경
    private func descriptionView() -> some View {
        // title / date / contents / placeName / addressName
        VStack(spacing: 10) {
            Text(diary.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(diary.isTimeIncluded ? diary.date.toString(DateFormat.untilTime) : diary.date.toString(DateFormat.untilWeekDay))")
            Text(diary.contents)
            Text(diary.placeName)
            Text(diary.addressName)
        }
        .font(.bold15)
        .foregroundStyle(Color(.appPrimary))
        .padding()
    }
}
