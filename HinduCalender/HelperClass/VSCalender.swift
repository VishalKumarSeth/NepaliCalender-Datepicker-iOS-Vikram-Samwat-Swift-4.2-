//
//  AppDelegate.swift
//  HinduCalender
//
//  Created by Book Keeper on 20/02/19.
//  Copyright © 2019 Book Keeper. All rights reserved.
//

import UIKit
struct convertedDate
{
    var year:Int
    var month:Int
    var date:Int
    var hindiMonth:String = ""
    
}

class VSCalender: NSObject
{
    static let shared = VSCalender()
    override init(){}
    
    static func show(view:UIViewController)
    {
        //let vscvc = view.storyboard?.instantiateViewController(withIdentifier: "VSCalenderViewController")as! VSCalenderViewController
        let vscvc = VSCalenderViewController.init(nibName: "VSCalenderViewController", bundle: nil)
        vscvc.providesPresentationContextTransitionStyle = true;
        vscvc.definesPresentationContext = true;
        vscvc.delegate=(view as! VSCalenderProtocol)
        vscvc.modalPresentationStyle = .overCurrentContext
        view.present(vscvc, animated: true, completion: nil)
    }
    
    static func EngToNepDate(yy:Int, mm:Int, dd: Int) -> convertedDate
    {
        let currentDateConverter = DateConverterHelper.init()
        currentDateConverter.engToNep(yy: yy, mm: mm, dd: dd)
        let con_year:Int = currentDateConverter.getConvertedYear()
        let con_month:Int = currentDateConverter.getConvertedMonth()
        let con_days:Int = currentDateConverter.getConvertedDays()
        let date = convertedDate.init(year: con_year, month: con_month, date: con_days, hindiMonth: currentDateConverter.getNepaliMonth(month: con_month))
        return date 
    }
    
    static func NepToEngDate(yy:Int, mm:Int, dd: Int) -> convertedDate
    {
        let currentDateConverter = DateConverterHelper.init()
        currentDateConverter.nepToEng(yy: yy, mm: mm, dd: dd)
        let con_year:Int = currentDateConverter.getConvertedYear()
        let con_month:Int = currentDateConverter.getConvertedMonth()
        let con_days:Int = currentDateConverter.getConvertedDays()
        let date = convertedDate.init(year: con_year, month: con_month, date: con_days, hindiMonth: currentDateConverter.getNepaliMonth(month: con_month))
        return date
    }
    
}
