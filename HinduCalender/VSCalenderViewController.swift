//
//  ViewController.swift
//  HinduCalender
//
//  Created by Book Keeper on 20/02/19.
//  Copyright © 2019 Book Keeper. All rights reserved.
//

import UIKit
import QuartzCore

protocol VSCalenderProtocol
{
    func selectedDate(date:Int,month:Int,year:Int,hindiMonthName:String)
    func NepToEngDate(yy:Int, mm:Int, dd: Int)
}


class VSCalenderViewController: UIViewController, UIPageViewControllerDelegate,ModelControllerDelegate {
    
    var delegate:VSCalenderProtocol?
    var pageViewController: UIPageViewController?
    var pendingIndex:Int!
    var currentIndex:Int!
    var pageObjectData:[PageData]!
    var selectedYear:Int!
    @IBOutlet weak var tblYear: UITableView!
    
    @IBOutlet weak var viewYear: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewCalender: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblYear.register(UINib(nibName: "YearCell", bundle: nil), forCellReuseIdentifier: "YearCell")
        viewYear.alpha=0.0
        viewCalender.dropShadow()
        //viewCalender.addShadowBorder()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSelectedDate(_:)), name: NSNotification.Name(rawValue: "selectedDateNotification"), object: nil)
        currentIndex = 0
        generateCalendar()
        
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self
        
        //let startingViewController=DataViewController.init(nibName: "DataViewController", bundle: nil)
        
        
        
        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(currentIndex)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
        
        self.pageViewController!.delegate = self
        self.pageViewController!.dataSource = self.modelController
        
        self.addChild(self.pageViewController!)
        self.viewCalender.addSubview(self.pageViewController!.view)
        self.viewCalender.sendSubviewToBack(self.pageViewController!.view)
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = CGRect.init(x: 0, y: 240, width: viewCalender.frame.size.width, height: btnCancel.frame.origin.y-240)
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        //pageViewRect = pageViewRect.insetBy(dx: 0, dy: 240)
        self.pageViewController!.view.frame = pageViewRect
        self.pageViewController!.view.frame.origin.y=240
        
        self.pageViewController!.didMove(toParent: self)
        
        let currentDate = DateConverterHelper.getCurrentDateAndMonth()
        titleLabel.text = NepaliTranslator.getMonth(month: currentDate.month) + " ("+NepaliTranslator.getNumber(english: "\(currentDate.year)")+")"
        
        
        
        
    }
    
    // MARK:  handle notification for selected date
    @objc func showSelectedDate(_ notification: NSNotification) {
       // print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            let selectedDate = dict["date"] as? Int
            //print(selectedDate!)
            self.lblCurrentDate.text="\(selectedDate!)"
            
            let selectedMonth = dict["month"] as? Int
            
            //print(selectedMonth!)
            
            let selectedYear = dict["year"] as? Int
            
            //print(selectedYear!)
            
            self.delegate?.selectedDate(date: selectedDate!, month: selectedMonth!, year: selectedYear!, hindiMonthName: NepaliTranslator.getMonth(month: selectedMonth!))
            
            let currentDateConverter = DateConverterHelper.init()
            
            currentDateConverter.nepToEng(yy: selectedYear!, mm: selectedMonth!, dd: selectedDate!)
            let con_year:Int = currentDateConverter.getConvertedYear()
            let con_month:Int = currentDateConverter.getConvertedMonth()
            let con_days:Int = currentDateConverter.getConvertedDays()
            
            self.delegate?.NepToEngDate(yy: con_year, mm: con_month, dd: con_days)
        }
    }
    
    private func generateCalendar(){
        
        // Create the data model.
        pageObjectData = []
        let currentDate = Calendar.current.dateComponents([.year,.month,.day], from: Date.init())
        let currentDateConverter = DateConverterHelper.init()
        
        currentDateConverter.engToNep(yy: currentDate.year!, mm: currentDate.month!, dd: currentDate.day!)
        
        let dateConverter = DateConverterHelper.init()
        
        currentDateConverter.engToNep(yy: currentDate.year!, mm: currentDate.month!, dd: currentDate.day!)
        dateConverter.engToNep(yy: currentDate.year!, mm: currentDate.month!, dd: currentDate.day!)
        let current_year = currentDateConverter.getConvertedYear()
        let current_month = currentDateConverter.getConvertedMonth()
        let current_day = currentDateConverter.getConvertedDays()
        let current_dayOfWeek = currentDateConverter.getConvertedDayOfWeek()
        let current_dayOfWeekNumber = currentDateConverter.getConvertedDayOfWeekNumber()
        
        
        selectedYear=current_year
        let indexPath = IndexPath(row: selectedYear-2006, section: 0)
        tblYear.scrollToRow(at: indexPath, at: .top, animated: true)
        
        var startDayOfWeek = currentDateConverter.getStartDateOfMonth(dayOfWeek:current_dayOfWeekNumber,day:current_day)
        let currentStartOfWeek = startDayOfWeek
        
        let numberOfDaysInMonth = currentDateConverter.getNumberOfDaysInMonth(year: current_year, month: current_month)
        var endDayOfWeek = currentDateConverter.getEndDateOfCurrentMonth(dayOfWeek: current_dayOfWeekNumber, day: numberOfDaysInMonth - current_day)
        let currentEndOfWeek = endDayOfWeek
        
        lblCurrentDate.text="\(current_day)"
        btnYear.setTitle("\(current_year)", for: .normal)
        lblMonth.text=DateConverterHelper.init().getNepaliMonth(month: current_month)
        
        
        for i in (2000...current_year).reversed(){
            for j in (1...12).reversed(){
                
                if current_year == i && current_month > j {
                    let daysInMonth = dateConverter.getNumberOfDaysInMonth(year: i, month: j)
                    if startDayOfWeek > 0 {
                        endDayOfWeek = startDayOfWeek - 1
                    }else{
                        endDayOfWeek = 6
                    }
                    startDayOfWeek = dateConverter.getStartDayOfMonth(dayOfWeek: endDayOfWeek, day: daysInMonth)
                    pageObjectData.append(PageData.init(month: j, year: i, startDayOfMonth: startDayOfWeek, endDayOfMonth: endDayOfWeek, numberOfDaysInMonth: daysInMonth, current: false))
                    
                }else if current_year != i{
                    let daysInMonth = dateConverter.getNumberOfDaysInMonth(year: i, month: j)
                    if startDayOfWeek > 0 {
                        endDayOfWeek = startDayOfWeek - 1
                    }else{
                        endDayOfWeek = 6
                    }
                    
                    startDayOfWeek = dateConverter.getStartDayOfMonth(dayOfWeek: endDayOfWeek, day: daysInMonth)
                    pageObjectData.append(PageData.init(month: j, year: i, startDayOfMonth: startDayOfWeek, endDayOfMonth: endDayOfWeek, numberOfDaysInMonth: daysInMonth, current: false))
                    
                    
                }
                
            }
        }
        pageObjectData = pageObjectData.reversed()
        startDayOfWeek = currentStartOfWeek
        endDayOfWeek = currentEndOfWeek
        
        for i in current_year...2090{
            for j in 1...12{
                
                if current_year == i && current_month == j {
                    
                    pageObjectData.append(PageData.init(month: j, year: i, startDayOfMonth: startDayOfWeek, endDayOfMonth: endDayOfWeek, numberOfDaysInMonth: numberOfDaysInMonth, current: true))
                    
                    currentIndex = pageObjectData.count - 1
                }else
                    if current_year == i && current_month < j {
                        let daysInMonth = dateConverter.getNumberOfDaysInMonth(year: i, month: j)
                        if endDayOfWeek < 6{
                            startDayOfWeek = endDayOfWeek + 1
                        }else if endDayOfWeek == 6{
                            startDayOfWeek = 0
                        }
                        endDayOfWeek = dateConverter.getEndDateOfMonth(dayOfWeek: startDayOfWeek, day: daysInMonth)
                        pageObjectData.append(PageData.init(month: j, year: i, startDayOfMonth: startDayOfWeek, endDayOfMonth: endDayOfWeek, numberOfDaysInMonth: daysInMonth, current: false))
                        
                    }
                    else if current_year != i
                    {
                        let daysInMonth = dateConverter.getNumberOfDaysInMonth(year: i, month: j)
                        if endDayOfWeek < 6{
                            startDayOfWeek = endDayOfWeek + 1
                        }else{
                            startDayOfWeek = 0
                        }
                        
                        endDayOfWeek = dateConverter.getEndDateOfMonth(dayOfWeek: startDayOfWeek, day: daysInMonth)
                        pageObjectData.append(PageData.init(month: j, year: i, startDayOfMonth: startDayOfWeek, endDayOfMonth: endDayOfWeek, numberOfDaysInMonth: daysInMonth, current: false))
                        
                }
                
            }
        }
        modelController.pageObjectData = pageObjectData
    }
    
    
    @IBAction func btnSelectYear(_ sender: Any)
    {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.viewYear.alpha=1.0
            if self.selectedYear>2002
            {
                let indexPath = IndexPath(row: self.selectedYear-2002, section: 0)
                self.tblYear.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            
        })
    }
    
    private func showTodayCalender(){
        
        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(currentIndex)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
    }
    
    private func goToPage(index:Int){
        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(index)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
        self.currentIndex = index
        let pageData = self.modelController.pageObjectData[index]
        let month = DateConverterHelper.init().getNepaliMonth(month: pageData.month)
        titleLabel.text = month + " ("+NepaliTranslator.getNumber(english: "\(pageData.year)")+")"
        
        lblMonth.text="\(month)"
        btnYear.setTitle("\(pageData.year)", for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
            self.modelController.delegate = self
        }
        return _modelController!
    }
    
    var _modelController: ModelController? = nil
    
    // MARK: - UIPageViewController delegate methods
    
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
            
            self.pageViewController!.isDoubleSided = false
            return .min
        }
        
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! DataViewController
        var viewControllers: [UIViewController]
        
        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
        return .mid
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = self.modelController.indexOfViewController(pendingViewControllers.first as! DataViewController)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed{
            // 2
            self.currentIndex = self.pendingIndex
            print(String(describing:currentIndex))
            let pageData = self.modelController.pageObjectData[pendingIndex]
            let month = DateConverterHelper.init().getNepaliMonth(month: pageData.month)
            titleLabel.text = month + " ("+NepaliTranslator.getNumber(english: "\(pageData.year)")+")"
            lblMonth.text="\(month)"
            btnYear.setTitle("\(pageData.year)", for: .normal)
            
        }
    }
    
    @IBAction func onPreviousButtonPressed(_ sender: UIButton) {
        
        goToPage(index: currentIndex - 1)
    }
    @IBAction func onNextButtonPressed(_ sender: UIButton) {
        goToPage(index: currentIndex + 1)
    }
    
    func didUpdateIndex(to: Int) {
        // self.uiControl.currentPage = to
    }
    
    // MARK: - Button Actions
    @IBAction func btnCancel(_ sender: Any)
    {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func btnOKAction(_ sender: Any)
    {
        self.dismiss(animated: true) {
            
        }
    }
    
    
    
}

// MARK: - Extentions
extension VSCalenderViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 91
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:YearCell = tableView.dequeueReusableCell(withIdentifier: "YearCell")as! YearCell
        cell.lblYear.text="\(2000+indexPath.row)"
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
        if cell.lblYear.text==String(selectedYear) {
            cell.lblYear.layer.cornerRadius=cell.lblYear.frame.size.width/2
            cell.lblYear.backgroundColor=UIColor.brown
            cell.lblYear.layer.masksToBounds=true
            cell.lblYear.textColor=UIColor.white
        }
        else
        {
            cell.lblYear.textColor=UIColor.black
            cell.lblYear.backgroundColor=UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedYear=2000+indexPath.row
        tableView.reloadData()
        btnYear.setTitle(String(selectedYear), for: .normal)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            
            self.viewYear.alpha=0.0
            let dh = DateConverterHelper.init()
            let total:Int=dh.getTotalNoOfMonth(year: self.selectedYear, month:0)
            self.goToPage(index: total)
            
            
            
        })
        
        
    }
}

