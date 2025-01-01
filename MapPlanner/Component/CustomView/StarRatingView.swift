//
//  StarRatingView.swift
//  MapPlanner
//
//  Created by 김성민 on 1/1/25.
//

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Double
    let maxRating: Int = 5
    
    let starSize: CGFloat = 30
    let starSpacing: CGFloat = 5
    
    var body: some View {
        HStack(spacing: starSpacing) {
            ForEach(0..<maxRating, id: \.self) { index in
                StarCell(fillAmount: max(0, min(1, (rating - Double(index)))))
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
