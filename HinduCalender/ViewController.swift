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
    func selectedDate(date: Int, month: Int, year: Int, hindiMonthName: String)
    {
        print(date)
        print(month)
        print(year)
        print(hindiMonthName)
    }
    
    func NepToEngDate(yy: Int, mm: Int, dd: Int) {
        print(yy)
        print(mm)
        print(dd)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOpenCalender(_ sender: Any)
    {
        VSCalender.show(view: self)
        let Data = VSCalender.EngToNepDate(yy: 2019, mm: 02, dd: 22)
        print(Data.date)
        print(Data.month)
        print(Data.year)
        print(Data.hindiMonth)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
