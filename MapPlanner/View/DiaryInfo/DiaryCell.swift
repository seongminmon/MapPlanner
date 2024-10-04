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
            Text(diary.date.toString(diary.isTimeIncluded ? DateFormat.untilTime : DateFormat.untilDay))
                .asTextModifier(font: .regular12, color: .appSecondary)
            Spacer()
            Text(diary.placeName)
                .asTextModifier(font: .bold12, color: .appPrimary)
            Text(diary.addressName)
                .asTextModifier(font: .regular12, color: .appSecondary)
        }
        .lineLimit(1)
        .padding(.vertical, 4)
    }
}
