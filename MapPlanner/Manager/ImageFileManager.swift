//
//  ImageFileManager.swift
//  MapPlanner
//
//  Created by 김성민 on 9/19/24.
//

import UIKit

final class ImageFileManager {
    static let shared = ImageFileManager()
    private init() {}
    
    // 도큐먼트 폴더 위치
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func saveImageFile(image: UIImage, filename: String) {
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            print("이미지 파일 저장 성공")
            try data.write(to: fileURL)
        } catch {
            print("이미지 파일 저장 실패", error)
        }
    }
    
    func loadImageFile(filename: String) -> UIImage? {
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return nil
        }
    }

    func deleteImageFile(filename: String) {
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                print("이미지 파일 삭제 성공")
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("이미지 파일 삭제 실패", error)
            }
        } else {
            print("이미지 파일 없음")
        }
    }
}
