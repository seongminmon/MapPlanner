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
                DispatchQueue.main.async {
                    self?.diaryList = results.map { $0.toDiary() }
                }
            }
        } catch {
            print("옵저버 세팅 실패")
        }
    }
    
    func dateFilteredDiaryList(_ date: Date) -> [Diary] {
        return diaryList
            .filter { $0.date.compareUntilDay(date) }
            .sorted { $0.savedDate > $1.savedDate }
    }
    
    func locationFilteredDiaryList(_ locationID: String?) -> [Diary] {
        return diaryList
            .filter { $0.locationID == locationID }
            .sorted {
                if $0.date == $1.date {
                    return $0.savedDate > $1.savedDate
                }
                return $0.date > $1.date
            }
    }
    
    func searchedDiaryList(_ query: String) -> [Diary] {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return [] }
        
        return diaryList
            .filter {
                $0.title.contains(query) ||
                $0.contents.contains(query) ||
                $0.placeName.contains(query) ||
                $0.addressName.contains(query) ||
                $0.category.contains(query)
            }
            .sorted {
                if $0.date == $1.date {
                    return $0.savedDate > $1.savedDate
                }
                return $0.date > $1.date
            }
    }
    
    func timeLineDiaryDict() -> [String: [Diary]] {
        let sortedList = diaryList.sorted {
            if $0.date == $1.date {
                return $0.savedDate > $1.savedDate
            }
            return $0.date > $1.date
        }
        
        var diaryDict = [String: [Diary]]()
        for diary in sortedList {
            let key = diary.date.toString(DateFormat.untilMonth)
            if diaryDict[key] != nil {
                diaryDict[key]?.append(diary)
            } else {
                diaryDict[key] = [diary]
            }
        }
        return diaryDict
    }
    
    func addDiary(diary: RealmDiary, image: UIImage?) {
        if let image {
            ImageFileManager.shared.saveImageFile(image: image, filename: diary.id.stringValue)
        }
        $realmDiaryList.append(diary)
        print("Realm 추가")
        
        let addToast = Toast(type: .success, title: "기록이 추가되었습니다")
        NotificationCenter.default.post(
            name: .showToast,
            object: nil,
            userInfo: [Notification.UserInfoKey.toast: addToast]
        )
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
            
            let deleteToast = Toast(type: .success, title: "기록이 삭제되었습니다")
            NotificationCenter.default.post(
                name: .showToast,
                object: nil,
                userInfo: [Notification.UserInfoKey.toast: deleteToast]
            )
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
                    diary.rating = newDiary.rating
                    diary.locationID = newDiary.locationID
                    diary.placeName = newDiary.placeName
                    diary.addressName = newDiary.addressName
                    diary.lat = newDiary.lat
                    diary.lng = newDiary.lng
                    diary.category = newDiary.category
                    realm.add(diary, update: .modified)
                }
            }
            if let image {
                ImageFileManager.shared.saveImageFile(image: image, filename: diaryID)
            } else {
                ImageFileManager.shared.deleteImageFile(filename: diaryID)
            }
            print("Realm 수정 성공")
            
            let updateToast = Toast(type: .success, title: "수정되었습니다")
            NotificationCenter.default.post(
                name: .showToast,
                object: nil,
                userInfo: [Notification.UserInfoKey.toast: updateToast]
            )
        } catch {
            print("Realm 수정 실패 \(error)")
        }
    }
}
