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
        
        var collectionViewCellCount: Int{
            startDayOfTheWeek + endDate + 7
        }
    }
    
    //MARK: - Properties
    
    var dateHandler: (() -> ())!
    
    private var calendar = Calendar.current
    
    private var calendarDate: Date!{
        didSet{
            updateCalendarInfo()
        }
    }
    
    private var calendarInfo: CalendarInfo!{
        didSet{
            updateCalendarTitleAndCollectionView()
        }
    }
    
    private var calendarDateFormatter = DateFormatter().then{
        $0.dateFormat = "yyyy년 M월"
    }
    
    let mainView = CalendarSheetView().then{
        $0.preMonthButton.addTarget(self, action: #selector(calendarChangeToLastMonth), for: .touchUpInside)
        $0.nextMonthButton.addTarget(self, action: #selector(calendarChangeToNextMonth), for: .touchUpInside)
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
    }
    
    //MARK: - Action
    
    @objc func calendarChangeToLastMonth(){
        calendarDate = calendar.date(byAdding: .month, value: -1, to: calendarDate)
    }
    
    @objc func calendarChangeToNextMonth(){
        calendarDate = calendar.date(byAdding: .month, value: 1, to: calendarDate)
    }
    
    //MARK: - Helper
    
    private func configureCalendar(){
        
        let components = calendar.dateComponents([.year, .month], from: Date())
        
        calendarDate = calendar.date(from: components) ?? Date()
    }
    
    private func getStartDayOfTheWeek() -> Int{
        calendar.component(.weekday, from: calendarDate) - 1
    }
    
    private func getEndDateOfTheMonth() -> Int{
        calendar.range(of: .day, in: .month, for: calendarDate)?.count ?? 0
    }
    
    private func updateCalendarInfo(){
        calendarInfo = CalendarInfo(startDayOfTheWeek: getStartDayOfTheWeek(),
                                    endDate: getEndDateOfTheMonth())
    }
    
    func updateCalendarTitleAndCollectionView(){
        mainView.yearMonthLabel.text = calendarDateFormatter.string(from: calendarDate)
        mainView.calendarCollectionView.reloadData()
    }
}

extension CalendarSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calendarInfo.collectionViewCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarSheetCollectionViewCell.cellIdentifier, for: indexPath) as? CalendarSheetCollectionViewCell else { return UICollectionViewCell() }
        
        let index = indexPath.row
        
        if(index < 7){
            cell.setDayOfTheWeekText(index: index)
        }else if(index < 7 + calendarInfo.startDayOfTheWeek){ //EmptyCell인 경우
            cell.infoLabel.text = nil
        }else{
            cell.infoLabel.text = "\(index - (calendarInfo.startDayOfTheWeek + 7) + 1)"
        }
        
        return cell
    }
}
