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
            HStack(alignment: .top, spacing: 8) {
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
                .resizable()
                .frame(width: 40, height: 40)
                .frame(width: 100, height: 100)
                .foregroundStyle(.appPrimary)
                .background(.lightSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private func descriptionView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(diary.title)
                .asTextModifier(font: .bold15, color: .appPrimary)
            HStack {
                Text(diary.date.toString(diary.isTimeIncluded ? DateFormat.untilTime : DateFormat.untilDay))
                    .asTextModifier(font: .regular12, color: .appSecondary)
                Spacer()
                // 평점 정보 있을 때만 표시
                if let rating = diary.rating {
                    StarRatingDisplayView(rating: rating, starSpacing: 3, starSize: 15, font: .regular12)
                }
            }
            Spacer()
            // 장소 정보 있을 때만 표시
            if diary.lng != nil {
                HStack(spacing: 8) {
                    Text(diary.placeName)
                        .asTextModifier(font: .bold12, color: .appPrimary)
                    Text(CategoryName(rawValue: diary.category) == nil ? "기타" : diary.category)
                        .asTextModifier(font: .regular12, color: .lightSecondary)
                }
                Text(diary.addressName)
                    .asTextModifier(font: .regular12, color: .appSecondary)
            }
        }
        .lineLimit(1)
        .padding(.vertical, 4)
    }
}
