//
//  DiaryCell.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import SwiftUI

struct DiaryCell: View {
    
    var diary: Diary
    @State var showDiaryDetailView = false
    
    var body: some View {
        Button {
            showDiaryDetailView.toggle()
        } label: {
            HStack(alignment: .top) {
                imageView()
                descriptionView()
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .fullScreenCover(isPresented: $showDiaryDetailView) {
            DiaryDetailView(diary: diary)
        }
    }
    
    @ViewBuilder
    private func imageView() -> some View {
        if let image = ImageFileManager.shared.loadImageFile(filename: "\(diary.id)") {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Image.calendar
                .foregroundStyle(Color(.appPrimary))
                .frame(width: 100, height: 100)
                .background(Color(.appSecondary))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private func descriptionView() -> some View {
        VStack(alignment: .leading) {
            Text(diary.title)
                .font(.bold15)
            Text(diary.date.toString(diary.isTimeIncluded ? DateFormat.untilTime : DateFormat.untilDay))
                .font(.regular12)
                .foregroundStyle(Color(.appSecondary))
            Spacer()
            Text(diary.placeName)
            Text(diary.addressName)
                .font(.regular12)
                .foregroundStyle(Color(.appSecondary))
        }
        .font(.bold14)
        .foregroundStyle(Color(.appPrimary))
        .padding(.vertical, 4)
    }
}
