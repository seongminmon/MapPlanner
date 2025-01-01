//
//  StarCell.swift
//  MapPlanner
//
//  Created by 김성민 on 1/1/25.
//

import SwiftUI

struct StarCell: View {
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
