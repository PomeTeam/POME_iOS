//
//  CalendarSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/12/20.
//

import UIKit

class CalendarSheetViewController: BaseSheetViewController {
    
    struct CalendarInfo{
        var startDayOfTheWeek: Int
        var endDate: Int
    }
    
    //MARK: - Properties
    
    var dateHandler: (() -> ())!
    
    private var calendar = Calendar.current
    private var calendarDate: Date!
    private var calendarInfo: CalendarInfo!
    private var calendarDateFormatter = DateFormatter().then{
        $0.dateFormat = "yyyy년 M월"
    }
    
    let mainView = CalendarSheetView().then{
        $0.preMonthButton.addTarget(CalendarSheetViewController.self, action: #selector(preMonthButtonDidClicked), for: .touchUpInside)
        $0.nextMonthButton.addTarget(CalendarSheetViewController.self, action: #selector(nextMonthButtonDidClicked), for: .touchUpInside)
    }
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Override

    override func style() {
        
        super.style()
        
        setBottomSheetStyle(type: .calendar)
    }

    override func layout() {
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func initialize() {
        
        super.initialize()
        
        mainView.calendarCollectionView.dataSource = self
        mainView.calendarCollectionView.delegate = self
        
        configureCalendar()
        updateCalendar()
    }
    
    //MARK: - Action
    
    @objc func preMonthButtonDidClicked(){
        
    }
    
    @objc func nextMonthButtonDidClicked(){
        
    }
    
    //MARK: - Helper
    
    private func configureCalendar(){
        
        let components = calendar.dateComponents([.year, .month], from: Date())
        
        calendarDate = calendar.date(from: components) ?? Date()
    }
    
    private func startDayOfTheWeek() -> Int{
        calendar.component(.weekday, from: calendarDate) - 1
    }
    
    private func endDate() -> Int{
        calendar.range(of: .day, in: .month, for: calendarDate)?.count ?? 0
    }
    
    private func updateTitle(){
        mainView.yearMonthLabel.text = calendarDateFormatter.string(from: calendarDate)
    }
    
    private func updateCalendarInfo(){
        
        calendarInfo = CalendarInfo(startDayOfTheWeek: startDayOfTheWeek(),
                                    endDate: endDate())
    }
    
    func updateCalendar(){
        updateTitle()
        updateCalendarInfo()
        mainView.calendarCollectionView.reloadData()
    }
    
    func minusMonth(){
        
    }
    
    func plusMonth(){
        
    }
}

extension CalendarSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7 + calendarInfo.endDate + calendarInfo.startDayOfTheWeek
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarSheetCollectionViewCell.cellIdentifier, for: indexPath) as? CalendarSheetCollectionViewCell else { return UICollectionViewCell() }
        
        let index = indexPath.row
        
        if(index < 7){
            cell.setDayOfTheWeekText(index: index)
        }else if(index < 7 + calendarInfo.startDayOfTheWeek){
            cell.infoLabel.text = nil
        }else{
            cell.infoLabel.text = "\(index - (calendarInfo.startDayOfTheWeek + 7) + 1)"
        }
        
        return cell
    }
}
