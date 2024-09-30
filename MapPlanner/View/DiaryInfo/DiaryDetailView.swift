//
//  DiaryDetailView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/22/24.
//

import SwiftUI
import RealmSwift

struct DiaryDetailView: View {
    
    // TODO: - 디자인 변경
    
    var diary: Diary
    @StateObject private var diaryManager = DiaryManager()
    
    @Environment(\.dismiss) private var dismiss
    @State private var showActionSheet = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 300) {
                    // 사진
                    imageView()
                    VStack(spacing: 10) {
                        Text(diary.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(diary.isTimeIncluded ? diary.date.toString(DateFormat.untilTime) : diary.date.toString(DateFormat.untilWeekDay))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(diary.contents)
                            .font(.regular14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text(diary.placeName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(diary.addressName)
                                .font(.regular14)
                                .foregroundStyle(Color(.appSecondary))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .font(.bold15)
                    .foregroundStyle(Color(.appPrimary))
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image.xmark
                    }
                    .foregroundStyle(Color(.appPrimary))
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showActionSheet.toggle()
                    } label: {
                        Image.ellipsis
                    }
                    .foregroundStyle(Color(.appPrimary))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    .frame(width: geometry.size.width, height: 300)
                    .clipped()
            }
        } else {
            GeometryReader { geometry in
                Image.calendar
                    .resizable()
                    .frame(width: 50, height: 50)
                    .frame(width: geometry.size.width, height: 300)
                    .foregroundStyle(Color(.appPrimary))
                    .background(Color(.appSecondary))
            }
        }
    }
}
