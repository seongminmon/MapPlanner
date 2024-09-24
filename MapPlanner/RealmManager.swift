//
//  RealmManager.swift
//  MapPlanner
//
//  Created by 김성민 on 9/24/24.
//

//import Foundation
//import RealmSwift
//
//final class RealmManager: ObservableObject {
//    
//    private(set) var localRealm: Realm?
//    @Published private(set) var plans: [Plan] = []
//    
//    init() {
//        openRealm()
//        fetchPlans()
//    }
//    
//    private func openRealm() {
//        do {
//            localRealm = try Realm()
//        } catch {
//            print("Realm Open 실패 \(error)")
//        }
//    }
//    
//    func fetchPlans() {
//        if let localRealm = localRealm {
//            print("fetch Plans 성공")
//            plans = Array(localRealm.objects(Plan.self))
//        } else {
//            print("fetch Plans 실패")
//        }
//    }
//    
//    func fetchFilteredPlans(_ date: Date) -> [Plan] {
//        if let localRealm = localRealm {
//            print("fetch Filtered Plans 성공")
//            fetchPlans()
//            return plans.filter { $0.date.compareYearMonthDay(date) }
//        }
//        print("fetch Filtered Plans 실패")
//        return []
//    }
//    
//    func add(plan: Plan) {
//        if let localRealm = localRealm {
//            do {
//                try localRealm.write {
//                    print("Realm 일정 추가 성공 \(plan)")
//                    localRealm.add(plan)
//                    fetchPlans()
//                }
//            } catch {
//                print("Realm 일정 추가 실패 \(error)")
//            }
//        }
//    }
//    
//    func update(id: ObjectId, newPlan: Plan) {
//        if let localRealm = localRealm {
//            do {
//                guard var target = localRealm.object(ofType: Plan.self, forPrimaryKey: id) else { return }
//                try localRealm.write {
//                    print("Realm 업데이트 성공")
//                    target = newPlan
//                    fetchPlans()
//                }
//            } catch {
//                print("Realm 업데이트 실패 \(error)")
//            }
//        }
//    }
//    
//    func delete(id: ObjectId) {
//        if let localRealm = localRealm {
//            do {
//                guard let target = localRealm.object(ofType: Plan.self, forPrimaryKey: id) else { return }
//                try localRealm.write {
//                    print("Realm 삭제 성공")
//                    localRealm.delete(target)
//                    fetchPlans()
//                }
//            } catch {
//                print("Realm 삭제 실패 \(error)")
//            }
//        }
//    }
//}
