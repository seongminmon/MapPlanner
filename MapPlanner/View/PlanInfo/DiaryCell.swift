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
                
                VStack(alignment: .leading) {
                    Text(diary.title)
                        .font(.bold15)
                        .foregroundStyle(Color(.appPrimary))
                    Text(diary.contents)
                        .font(.regular13)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color(.appSecondary))
                        .lineLimit(2)
                    Text(diary.placeName)
                        .font(.bold15)
                        .foregroundStyle(Color(.appPrimary))
                    Text(diary.addressName)
                        .font(.regular13)
                        .foregroundStyle(Color(.appPrimary))
                }
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showDiaryDetailView) {
            DiaryDetailView(diary: diary)
        }
    }
}
