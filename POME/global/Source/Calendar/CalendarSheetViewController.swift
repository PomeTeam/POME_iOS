//
//  CalendarSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/12/20.
//

import UIKit

struct CalendarSelectDate{
    var year: Int
    var month: Int
    var date: Int
}

class CalendarSheetViewController: BaseSheetViewController {
    
    struct CalendarInfo{
        
        var startDayOfTheWeek: Int
        var endDate: Int
        
        var collectionViewCellCount: Int{
            startDayOfTheWeek + endDate + 7
        }
        
        var collectionViewStartDateIndex: Int{
            startDayOfTheWeek + 7
        }
    }
    
    //MARK: - Properties
    
    var selectDate: CalendarSelectDate!
    var completion: ((CalendarSelectDate) -> ())!
    
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
    
    private let mainView = CalendarSheetView().then{
        $0.lastMonthButton.addTarget(self, action: #selector(calendarWillChangeToLastMonth), for: .touchUpInside)
        $0.nextMonthButton.addTarget(self, action: #selector(calendarWillChangeToNextMonth), for: .touchUpInside)
        $0.completeButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)
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
        
        initializeCalendarDate()
    }
    
    //MARK: - Action
    
    @objc private func calendarWillChangeToLastMonth(){
        calendarDate = calendar.date(byAdding: .month, value: -1, to: calendarDate)
    }
    
    @objc private func calendarWillChangeToNextMonth(){
        calendarDate = calendar.date(byAdding: .month, value: 1, to: calendarDate)
    }
    
    @objc private func completeButtonDidClicked(){
        completion(selectDate)
        self.dismiss(animated: true)
    }
    
    //MARK: - Helper
    
    private func initializeCalendarDate(){
        
        let components = calendar.dateComponents([.year, .month], from: Date())
        
        calendarDate = calendar.date(from: components) ?? Date()
    }
    
    private func getStartDayOfMonth() -> Int{
        calendar.component(.weekday, from: calendarDate) - 1
    }
    
    private func getEndDateOfMonth() -> Int{
        calendar.range(of: .day, in: .month, for: calendarDate)?.count ?? 0
    }
    
    private func updateCalendarInfo(){
        calendarInfo = CalendarInfo(startDayOfTheWeek: getStartDayOfMonth(),
                                    endDate: getEndDateOfMonth())
    }
    
    private func updateCalendarTitleAndCollectionView(){
        mainView.yearMonthLabel.text = calendarDateFormatter.string(from: calendarDate)
        mainView.calendarCollectionView.reloadData()
    }
    
    private func storageSelectDateAndActivateCompleButton(_ date: Int){
        
        let year = calendar.component(.year, from: calendarDate)
        let month = calendar.component(.month, from: calendarDate)
        
        guard var selectDate = selectDate else {
            mainView.completeButton.isActivate(true)
            selectDate = CalendarSelectDate(year: year,
                                            month: month,
                                            date: date)
            return
        }
        
        selectDate.year = year
        selectDate.month = month
        selectDate.date = date
        
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
        }else if(index >= calendarInfo.collectionViewStartDateIndex){
            cell.infoLabel.text = "\(index - calendarInfo.collectionViewStartDateIndex + 1)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        indexPath.row < calendarInfo.collectionViewStartDateIndex ? false : true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarSheetCollectionViewCell,
              let text = cell.infoLabel.text, let date = Int(text) else { return }
        
        cell.changeViewAttributesByState(.selected)
        storageSelectDateAndActivateCompleButton(date)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarSheetCollectionViewCell else { return }
        cell.changeViewAttributesByState(.normal)
    }
}
