//
//  ReportViewController.swift
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-15.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    struct ShiftRange {
        var startTime: String
        var endTime: String
        var title: String
        var alert: Int
        
        func addHour(date: Date) -> (Date, Date)? {
            let stringFormatter = DateFormatter()
            stringFormatter.dateFormat = "yyyy/MM/dd"
            let dateString = stringFormatter.string(from: date)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            let start = dateFormatter.date(from: dateString+" "+startTime)
            let end = dateFormatter.date(from: dateString+" "+endTime)
            
            if let start = start,
                let end = end {
                return (start, end)
            }
            return nil
        }
    }
    
    struct ReportData {
        var date: Date
        var night: Int
        var morning: Int
        var afternoon: Int
        var evening: Int
    }
    
    var dayShift = [Date:[Int]]()
    var reportData: [ReportData] = []
    
    var delegate: WaiterDelegate?
    private var night: ShiftRange?
    private var morning: ShiftRange?
    private var afternoon: ShiftRange?
    private var evening: ShiftRange?

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createShiftRange()
        calculate()
        tableview.delegate = self
        tableview.dataSource = self

        self.navigationItem.title = "Shifts Map"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func homeButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func createShiftRange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        night = ShiftRange(startTime: "00:00",
                           endTime: "06:00",
                           title: "Special",
                           alert: 1)
        
        morning = ShiftRange(startTime: "06:01",
                             endTime: "12:00",
                             title: "Morning",
                             alert: 1)
        afternoon = ShiftRange(startTime: "12:01",
                               endTime: "18:00",
                               title: "Afternoon",
                               alert: 2)
        evening = ShiftRange(startTime: "18:01",
                           endTime: "23:59",
                           title: "Evening",
                           alert: 3)
    }
    
    private func calculate () {
        if let delegate = delegate {
            let (error, shifts) = delegate.getAllShifts()
            
            for shift in shifts {
                let startDate = shift.start
                var shiftRange: ShiftRange?
                
                if let night = night,
                    let morning = morning,
                    let afternoon = afternoon,
                    let evening = evening {
                    
                    if insideRange(date: startDate, shiftRange: night) {
                        shiftRange = night
                    } else if insideRange(date: startDate, shiftRange: morning) {
                        shiftRange = morning
                    } else if insideRange(date: startDate, shiftRange: afternoon) {
                        shiftRange = afternoon
                    } else if insideRange(date: startDate, shiftRange: evening) {
                        shiftRange = evening
                    }
                    
                    if let shiftRange = shiftRange {
                        let quantity = calculateQuantity(date: startDate, shiftRange: shiftRange)
                        dayShift.updateValue(quantity, forKey: getDate(from: startDate))
                    }
                }
            }
            
            convertData()
            
            if error {
                let alert = UIAlertController(title: "Missing information",
                                              message: "It was not possible to read all recorded shifts. Please, contact support.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    private func calculateQuantity(date: Date, shiftRange: ShiftRange) -> [Int] {
        var index: Int = 0
        
        switch shiftRange.title {
        case "Special":
            index = 0
        case "Morning":
            index = 1
        case "Afternoon":
            index = 2
        default:
            index = 3
        }
        
        if var quantity = dayShift[getDate(from: date)] {
            quantity[index] += 1
            return quantity
        } else {
            var quantity = [0, 0, 0, 0]
            quantity[index] += 1
            return quantity
        }
    }
    
    private func convertData() {
        var result: [ReportData] = []
        
        for day in dayShift {
            result.append(ReportData(date: day.key, night: day.value[0], morning: day.value[1], afternoon: day.value[2], evening: day.value[3]))
        }
        reportData = result.sorted(by: {$0.date < $1.date } )
    }
    
    private func insideRange(date: Date, shiftRange: ShiftRange) -> Bool {
        if let (startRange, endRange) = shiftRange.addHour(date: date) {
            if date >= startRange && date <= endRange {
                return true
            }
        }
        return false
    }
    
    private func getHour(from date: Date) -> Date {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        let time = hourFormatter.string(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let newDate = dateFormatter.date(from: "1900/01/01 "+time)
        
        return newDate!
    }
    
    private func getDate(from date: Date) -> Date {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dayFormatter.string(from: date)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        return formatter.date(from: dateString+" 00:00")!
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for:indexPath) as? ReportTableViewCell {
            let index = indexPath.row
            if index == 0 {
                cell.dateLabel.text = ""
                cell.specialLabel.text = "Special"
                cell.morningLabel.text = "Morning"
                cell.afternoonLabel.text = "Afternoon"
                cell.eveningLabel.text = "Evening"
            } else {
                let line = reportData[index-1]
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd"
                cell.dateLabel.text = formatter.string(from: line.date)
                cell.specialLabel.text = "\(line.night)"
                cell.morningLabel.text = "\(line.morning)"
                cell.afternoonLabel.text = "\(line.afternoon)"
                cell.eveningLabel.text = "\(line.evening)"
            }
            
            return cell
        }
        return ReportTableViewCell()
    }
    
    
    
}
