//
//  HomeViewController.swift
//  Dailist
//
//  Created by 안지희 on 3/17/25.
//

import UIKit
import FSCalendar

class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource{

    private let calendar = FSCalendar()
    private let tableView = UITableView()
    
    private var events: [String: [String: [String]]] = [:]  // 날짜 -> 카테고리 -> 일정 목록
    private var selectedDate: String = ""
    private var selectedDateCategories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCalendar()
        setupTableView()
    }
    
    //캘린더
    private func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    //일정 테이블
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }

    
    //달력 -> 날짜별 일정 로드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(from: date)

        selectedDateCategories = events[selectedDate]?.keys.isEmpty == false ? Array(events[selectedDate]!.keys) : ["공부", "일상", "개발"]
        tableView.reloadData()
    }

    //테이블뷰 섹션 개수 (카테고리 리스트만큼)
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedDateCategories.count
    }
    
    //각 카테고리 내의 행 개수 지정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = selectedDateCategories[section] // 섹션의 카테고리 가져오기
        return events[selectedDate]?[category]?.count ?? 0 // 해당 카테고리에 속한 일정 개수 반환
    }


    //카테고리 view 호출해서 사용
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let categoryHeader = CategoryHeaderView()
        let category = selectedDateCategories[section]
        
        categoryHeader.categoryName = category
        categoryHeader.addButtonTapped = {
            self.addEvent(for: self.selectedDate, category: category)
        }
        
        return categoryHeader
    }
    
    //각 행 (일정)별 셀 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = selectedDateCategories[indexPath.section]
        let eventList = events[selectedDate]?[category] ?? []
        cell.textLabel?.text = eventList[indexPath.row]
        return cell
    }


    //일정추가 이벤트
    private func addEvent(for date: String, category: String) {
        let alert = UIAlertController(title: "\(date) 일정 추가", message: "일정을 입력하세요", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "예: 과제 제출, 헬스"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { _ in
            if let eventText = alert.textFields?.first?.text, !eventText.isEmpty {
                if self.events[date] == nil {
                    self.events[date] = [:]
                }
                if self.events[date]?[category] == nil {
                    self.events[date]?[category] = []
                }
                self.events[date]?[category]?.append(eventText)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
//프리뷰

#if DEBUG
import SwiftUI

struct HomeViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeViewController {
        return HomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {}
}

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewControllerPreview()
    }
}
#endif
