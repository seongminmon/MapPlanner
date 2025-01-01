//
//  StarRatingDisplayView.swift
//  MapPlanner
//
//  Created by 김성민 on 1/1/25.
//

import SwiftUI

struct StarRatingDisplayView: View {
    let rating: Double
    let maxRating: Int = 5
    
    let starSpacing: CGFloat
    let starSize: CGFloat
    let font: Font
    
    init(rating: Double, starSpacing: CGFloat = 10, starSize: CGFloat = 30, font: Font = .bold18) {
        self.rating = rating
        self.starSpacing = starSpacing
        self.starSize = starSize
        self.font = font
    }
    
    var body: some View {
        HStack(spacing: starSpacing) {
            Image.starFill
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.yellow)
                .frame(width: starSize, height: starSize)
            Text(String(format: "%.1f", rating))
                .asTextModifier(font: font, color: .appPrimary)
        }
    }
}
