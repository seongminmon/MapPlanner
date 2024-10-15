//
//  NMFMarker+.swift
//  MapPlanner
//
//  Created by 김성민 on 10/15/24.
//

import Foundation
import NMapsMap

extension NMFMarker {
    static var customMarker: NMFMarker {
        let marker = NMFMarker()
        // 아이콘 설정
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor(resource: .darkTheme)
        
        // 캡션 설정
        marker.captionRequestedWidth = 100
        marker.captionColor = UIColor(resource: .darkTheme)
        marker.captionHaloColor = .white
        
        marker.isHideCollidedSymbols = true
        
        return marker
    }
}
