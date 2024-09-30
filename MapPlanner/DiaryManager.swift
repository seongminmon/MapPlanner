//
//  RealmManager.swift
//  MapPlanner
//
//  Created by 김성민 on 9/27/24.
//

import UIKit
import RealmSwift

final class DiaryManager: ObservableObject {
    @ObservedResults(RealmDiary.self) var realmDiaryList
    @Published var diaryList: [Diary] = []
    
    private var token: NotificationToken?
    
    init() {
        setupObserver()
    }
    
    deinit {
        token?.invalidate()
    }
    
    private func setupObserver() {
        do {
            let realm = try Realm()
            let results = realm.objects(RealmDiary.self)
            token = results.observe{ [weak self] changes in
                self?.diaryList = results.map { $0.toDiary() }
            }
        } catch let error {
            print("옵저버 세팅 실패")
            print(error.localizedDescription)
        }
    }
    
    func dateFilteredDiaryList(_ date: Date) -> [Diary] {
        return diaryList.filter { $0.date.compareYearMonthDay(date) }
    }
    
    func locationFilteredDiaryList(_ locationID: String?) -> [Diary] {
        return diaryList.filter { $0.locationID == locationID }
    }
    
    func searchedDiaryList(_ query: String) -> [Diary] {
        return diaryList.filter {
            $0.title.contains(query) ||
            $0.contents.contains(query) ||
            $0.placeName.contains(query) ||
            $0.addressName.contains(query)
        }
    }
    
    func addDiary(diary: RealmDiary, image: UIImage?) {
        if let image {
            ImageFileManager.shared.saveImageFile(image: image, filename: diary.id.stringValue)
        }
        $realmDiaryList.append(diary)
        print("Realm 추가")
    }
    
    func deleteDiary(diaryID: String) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: diaryID)
            if let diary = realm.object(ofType: RealmDiary.self, forPrimaryKey: objectId) {
                try realm.write {
                    realm.delete(diary)
                }
            }
            ImageFileManager.shared.deleteImageFile(filename: diaryID)
            print("Realm 삭제 성공")
        } catch {
            print("Realm 삭제 실패 \(error)")
        }
    }
    
    func updateDiary(diaryID: String, newDiary: Diary, image: UIImage?) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: diaryID)
            if let diary = realm.object(ofType: RealmDiary.self, forPrimaryKey: objectId) {
                try realm.write {
                    diary.savedDate = Date()
                    diary.title = newDiary.title
                    diary.date = newDiary.date
                    diary.isTimeIncluded = newDiary.isTimeIncluded
                    diary.contents = newDiary.contents
                    diary.locationID = newDiary.locationID
                    diary.placeName = newDiary.placeName
                    diary.addressName = newDiary.addressName
                    diary.lat = newDiary.lat
                    diary.lng = newDiary.lng
                    realm.add(diary, update: .modified)
                }
            }
            if let image {
                ImageFileManager.shared.saveImageFile(image: image, filename: diaryID)
            } else {
                ImageFileManager.shared.deleteImageFile(filename: diaryID)
            }
            print("Realm 업데이트 성공")
        } catch {
            print("Realm 업데이트 실패 \(error)")
        }
    }
}
