//
//  CalendarSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/12/20.
//

import UIKit
import RxSwift

struct CalendarSelectDate{
    var year: Int
    var month: Int
    var date: Int
}

@objc protocol CalendarViewModel{
    @objc optional func selectConsumeDate(_ date: String)
    @objc optional func selectConsumeDate(tag: Int, _ date: String)
}

class CalendarSheetViewController: BaseSheetViewController, ObservableBinding {
    
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
    
    private let dateSubject = PublishSubject<Int>()
    var disposeBag = DisposeBag()
    func bind() {
        
        let selectDate = dateSubject
            .map{
                let year = self.calendar.component(.year, from: self.calendarDate)
                let month = self.calendar.component(.month, from: self.calendarDate)
                return CalendarSelectDate(year: year, month: month, date: $0)
            }
        
        dateSubject
            .first()
            .map{ _ in
                true
            }.asDriver(onErrorJustReturn: false)
            .drive(mainView.completeButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        mainView.completeButton.rx.tap
            .withLatestFrom(selectDate)
            .map{
                PomeDateFormatter.getDateString($0)
            }.subscribe{ [weak self] in
                self?.completion($0)
                self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
    
    
    //MARK: - Properties
    
    var completion: ((String) -> Void)!
    
    let calendar = Calendar.current
    var calendarDate: Date!{
        didSet{
            updateCalendarInfo()
        }
    }
    var calendarInfo: CalendarInfo!{
        didSet{
            updateCalendarTitleAndCollectionView()
        }
    }
    private var calendarDateFormatter = DateFormatter().then{
        $0.dateFormat = "yyyy년 M월"
    }
    
    let mainView = CalendarSheetView()
    
    //MARK: - LifeCycle

    init(){
        super.init(type: .calendar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    //MARK: - Override

    override func layout() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize() {
        
        super.initialize()
        
        mainView.calendarCollectionView.dataSource = self
        mainView.calendarCollectionView.delegate = self
        
        mainView.lastMonthButton.addTarget(self, action: #selector(calendarWillChangeToLastMonth), for: .touchUpInside)
        mainView.nextMonthButton.addTarget(self, action: #selector(calendarWillChangeToNextMonth), for: .touchUpInside)
        
        initializeCalendarDate()
    }
    
    //MARK: - Action
    
    @objc private func calendarWillChangeToLastMonth(){
        calendarDate = calendar.date(byAdding: .month, value: -1, to: calendarDate)
    }
    
    @objc private func calendarWillChangeToNextMonth(){
        calendarDate = calendar.date(byAdding: .month, value: 1, to: calendarDate)
    }
    
    //MARK: - Helper
    
    func initializeCalendarDate(){
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
}

extension CalendarSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calendarInfo.collectionViewCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CalendarSheetCollectionViewCell.self)

        //TODO: 다른 달 갔다가 다시 돌아오면 선택 해제되어 있음
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
        dateSubject.onNext(date)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarSheetCollectionViewCell else { return }
        cell.changeViewAttributesByState(.normal)
    }
}
