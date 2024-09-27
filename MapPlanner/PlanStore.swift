//
//  RealmManager.swift
//  MapPlanner
//
//  Created by 김성민 on 9/27/24.
//

import UIKit
import RealmSwift

final class PlanStore: ObservableObject {
    @ObservedResults(Plan.self) var plans
    @Published var outputPlans: [PlanOutput] = []
    
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
            let results = realm.objects(Plan.self)
            token = results.observe{ [weak self] changes in
                self?.outputPlans = results.map { $0.toPlanOutput() }
            }
        } catch let error {
            print("옵저버 세팅 실패")
            print(error.localizedDescription)
        }
    }
    
    func addPlan(plan: Plan, image: UIImage?) {
        if let image {
            ImageFileManager.shared.saveImageFile(image: image, filename: plan.id.stringValue)
        }
        $plans.append(plan)
        print("Realm 추가")
    }
    
    func deletePlan(planID: String) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: planID)
            if let plan = realm.object(ofType: Plan.self, forPrimaryKey: objectId) {
                try realm.write {
                    realm.delete(plan)
                }
            }
            ImageFileManager.shared.deleteImageFile(filename: planID)
            print("Realm 삭제 성공")
        } catch {
            print("Realm 삭제 실패 \(error)")
        }
    }
    
    func updatePlan(planID: String, newPlan: PlanOutput, image: UIImage?) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: planID)
            if let plan = realm.object(ofType: Plan.self, forPrimaryKey: objectId) {
                try realm.write {
                    plan.savedDate = Date()
                    plan.title = newPlan.title
                    plan.date = newPlan.date
                    plan.isTimeIncluded = newPlan.isTimeIncluded
                    plan.contents = newPlan.contents
                    plan.locationID = newPlan.locationID
                    plan.placeName = newPlan.placeName
                    plan.addressName = newPlan.addressName
                    plan.lat = newPlan.lat
                    plan.lng = newPlan.lng
                    realm.add(plan, update: .modified)
                }
            }
            if let image {
                ImageFileManager.shared.saveImageFile(image: image, filename: planID)
            } else {
                ImageFileManager.shared.deleteImageFile(filename: planID)
            }
            print("Realm 업데이트 성공")
        } catch {
            print("Realm 업데이트 실패 \(error)")
        }
    }
}
