//
//  ViewController.swift
//  HinduCalender
//
//  Created by VISHAL SETH on 2/23/19.
//  Copyright © 2019 Book Keeper. All rights reserved.
//

import UIKit

class ViewController: UIViewController,VSCalenderProtocol
{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOpenCalender(_ sender: Any)
    {
        VSCalender.show(view: self) // Call this method to show calender into you view controller
        
        // call converter method to convert any given english date to Nepali/Hindi date
        let Data = VSCalender.EngToNepDate(yy: 2019, mm: 02, dd: 22)
        
        print(Data.date)
        print(Data.month)
        print(Data.year)
        print(Data.hindiMonth)
    }
    
    // MARK: ------Delegates method (Hindi to english and vice versa)
    func selectedDate(date: Int, month: Int, year: Int, hindiMonthName: String)
    {
        print(date)
        print(month)
        print(year)
        print(hindiMonthName) // Got here selected Nepali/Hindi date with Hindi month name
    }
    
    func NepToEngDate(yy: Int, mm: Int, dd: Int) {
        print(yy)
        print(mm)
        print(dd) // Got here selected Nepali/Hindi date to english date
    }
    
    
    

}
