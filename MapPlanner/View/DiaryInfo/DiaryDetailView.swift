//
//  DiaryDetailView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/22/24.
//

import SwiftUI
import RealmSwift

struct DiaryDetailView: View {
    
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
            .toolbar(.hidden, for: .navigationBar)
            .overlay {
                VStack {
                    HStack {
                        Image.xmark
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color(.white))
                            .onTapGesture {
                                dismiss()
                            }
                        Spacer()
                        Image.ellipsis
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                            .foregroundStyle(Color(.white))
                            .onTapGesture {
                                showActionSheet.toggle()
                            }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            // Action Sheet
            .confirmationDialog("", isPresented: $showActionSheet) {
                NavigationLink {
                    EditDiaryView(diary: diary, selectedDate: nil)
                } label: {
                    Text("수정")
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
                    .frame(width: 80, height: 80)
                    .offset(y: 20)
                    .frame(width: geometry.size.width, height: 350)
                    .foregroundStyle(Color(.appPrimary))
                    .background(Color(.appSecondary))
            }
        }
    }
    
    private func descriptionView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(diary.title)
                .font(.bold20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image.calendar
                Text("\(diary.isTimeIncluded ? diary.date.toString(DateFormat.untilTime) : diary.date.toString(DateFormat.untilWeekDay))")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(diary.contents)
                .font(.regular13)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 장소 정보 있을 때 지도로 표시
            if diary.lat != nil {
                locationView()
            }
        }
        .font(.bold15)
        .foregroundStyle(Color(.appPrimary))
        .padding()
    }
    
    private func locationView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image.location
                VStack(alignment: .leading) {
                    Text(diary.placeName)
                    Text(diary.addressName)
                        .font(.regular12)
                        .foregroundStyle(Color(.appSecondary))
                }
            }
            
            SubMapView(
                lat: diary.lat ?? Location.defaultLat,
                lng: diary.lng ?? Location.defaultLng
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 200)
            .allowsHitTesting(false)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
}
