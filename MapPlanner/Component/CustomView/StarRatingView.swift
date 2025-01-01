//
//  StarRatingView.swift
//  MapPlanner
//
//  Created by 김성민 on 1/1/25.
//

import SwiftUI

// 기본이 되는 별 모양 셀 뷰
struct StarCellView: View {
    let fillAmount: Double
    
    let starSize: CGFloat = 30
    let fillColor: Color = .yellow
    let emptyColor: Color = .gray
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            ZStack {
                Image.starFill
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(emptyColor)
                
                Image.starFill
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(fillColor)
                    .mask(
                        Rectangle()
                            .size(
                                width: width * CGFloat(max(0, min(1, fillAmount))),
                                height: geometry.size.height
                            )
                    )
            }
        }
        .frame(width: starSize, height: starSize)
    }
}

// 인터랙티브한 별점 선택 뷰
struct StarRatingView: View {
    @Binding var rating: Double
    let maxRating: Int = 5
    
    let starSize: CGFloat = 30
    let starSpacing: CGFloat = 5
    
    var body: some View {
        HStack(spacing: starSpacing) {
            ForEach(0..<maxRating, id: \.self) { index in
                StarCellView(fillAmount: max(0, min(1, (rating - Double(index)))))
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // 드래그한 전체 위치를 기준으로 별점 계산
                                let containerWidth = CGFloat(maxRating) * (starSize + starSpacing)
                                let location = value.location.x + (CGFloat(index) * (starSize + starSpacing))
                                let ratio = location / containerWidth
                                
                                // 전체 너비에 대한 비율을 별점으로 변환
                                var newRating = ratio * Double(maxRating)
                                
                                // 0.5 단위로 반올림
                                newRating = round(newRating * 2) / 2
                                rating = min(max(newRating, 0), Double(maxRating))
                            }
                    )
            }
        }
    }
}

// 읽기 전용 별점 표시 뷰
struct StarRatingDisplayView: View {
    let rating: Double
    let maxRating: Int = 5
    let starSpacing: CGFloat = 5
    
    var body: some View {
        HStack(spacing: starSpacing) {
            Image.starFill
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.yellow)
                .frame(width: 30, height: 30)
            Text(String(format: "%.1f", rating))
                .asTextModifier(font: .bold18, color: .appPrimary)
        }
    }
}
