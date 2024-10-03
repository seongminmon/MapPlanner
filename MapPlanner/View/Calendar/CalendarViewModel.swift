//
//  CalendarViewModel.swift
//  MapPlanner
//
//  Created by 김성민 on 9/24/24.
//

import Foundation
import Combine

final class CalendarViewModel: ViewModelType {
    
    private let calendar = Calendar.current
    
    struct Input {
        let changeMonthButtonTap = PassthroughSubject<Int, Never>()
        let showDatePickerButtonTap = PassthroughSubject<Void, Never>()
        let refreshButtonTap = PassthroughSubject<Void, Never>()
        let moveDateButtonTap = PassthroughSubject<Void, Never>()
        let dayCellTap = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        // 달력 표시되고 있는 달 (연/월까지 유효)
        var currentDate = Date().getFirstDate() ?? Date()
        // 유저가 선택한 날짜 (연/월/일까지 유효)
        var clickedDate: Date?
        
        // 데이트 피커 관련
        var showDatePicker = false
        var selectedYear = Calendar.current.component(.year, from: Date())
        var selectedMonth = Calendar.current.component(.month, from: Date())
    }
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
    
    func transform() {
        input.changeMonthButtonTap
            .sink { [weak self] value in
                self?.changeMonth(by: value)
            }
            .store(in: &cancellables)
        
        input.showDatePickerButtonTap
            .sink { [weak self] _ in
                self?.setDatePicker()
                self?.output.showDatePicker.toggle()
            }
            .store(in: &cancellables)
        
        input.refreshButtonTap
            .sink { [weak self] _ in
                self?.output.currentDate = Date().getFirstDate() ?? Date()
            }
            .store(in: &cancellables)
        
        input.moveDateButtonTap
            .sink { [weak self] _ in
                self?.setCurrentDateToDatePickerDate()
                self?.output.showDatePicker = false
            }
            .store(in: &cancellables)
        
        input.dayCellTap
            .sink { [weak self] index in
                self?.output.clickedDate = self?.getDate(for: index)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    // 인덱스로 date 구하기
    func getDate(for index: Int) -> Date {
        let startDate = output.currentDate.getFirstDate() ?? Date()
        return calendar.date(byAdding: .day, value: index, to: startDate) ?? Date()
    }
    
    // 달력 이동
    private func changeMonth(by value: Int) {
        output.currentDate = output.currentDate.byAddingMonth(value) ?? Date()
    }
    
    // 달력 이동이 가능한지
    func canMoveMonth(_ value: Int) -> Bool {
        guard let tagetDate = output.currentDate.byAddingMonth(value) else { return false }
        return Date.startDate <= tagetDate && tagetDate <= Date.endDate
    }
    
    // 데이트 피커 초기값 세팅
    private func setDatePicker() {
        output.selectedYear = calendar.component(.year, from: output.currentDate)
        output.selectedMonth = calendar.component(.month, from: output.currentDate)
    }
    
    // 현재 날짜를 데이트 피커로 지정한 날짜로 변경
    private func setCurrentDateToDatePickerDate() {
        let components = DateComponents(year: output.selectedYear, month: output.selectedMonth)
        output.currentDate = calendar.date(from: components) ?? Date()
    }
}
