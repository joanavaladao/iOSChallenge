//
//  ShiftListViewController.swift
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-14.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import UIKit

protocol ShiftListDelegate {
    func setDelegate(_ delegate: ShiftDataDelegate)
    func reload()
    func show()
    func update()
    func delete()
}

class ShiftListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: ShiftDataDelegate?
    
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        if section == 0 {
            if let delegate = delegate {
                return delegate.quantityOfShifts()
            }
        } else {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "shiftCell", for:indexPath) as? ShiftTableViewCell,
                let delegate = delegate {
                let index = indexPath.row
                let shift = delegate.shiftAt(index)
                if let start = shift?.start,
                    let end = shift?.end {
                    cell.startShiftLabel.text = formatDate(date: start)
                    cell.endShiftLabel.text = formatDate(date: end)
                }
                return cell
            }
            return ShiftTableViewCell()
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? ButtonTableViewCell {
                cell.buttonCell.tag = indexPath.row
                cell.buttonCell.addTarget(self, action: #selector(addShiftButton(sender:)), for: .touchUpInside)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    @objc func addShiftButton(sender: UIButton) {
        print("activate button")
        if let delegate = delegate {
            delegate.showShiftDetail()
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let delegate = delegate,
            let shift = delegate.shiftAt(indexPath.row) {
            delegate.deleteShift(shift, index: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Shifts"
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "System", size: 14.0), size: 14.0)
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
//        <#code#>
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, dd HH:mm"
        var dateString = dateFormatter.string(from:date)
        
        let weekday = Calendar.current.component(.weekday, from: date)
        var weekdayString: String
        switch weekday {
        case 1:
            weekdayString = "Sunday"
        case 2:
            weekdayString = "Monday"
        case 3:
            weekdayString = "Tuesday"
        case 4:
            weekdayString = "Wednesday"
        case 5:
            weekdayString = "Thursday"
        case 6:
            weekdayString = "Friday"
        case 7:
            weekdayString = "Saturday"
        default:
            weekdayString = ""
        }
        return "\(weekdayString), \(dateString)"
    }

}

//TODO: implement functions
extension ShiftListViewController: ShiftListDelegate {
    
    func setDelegate(_ delegate: ShiftDataDelegate) {
        self.delegate = delegate
    }
    
    func reload() {
        tableview.reloadData()
    }
    
    func show() {
        print("read")
    }
    
    func update() {
        print("update")
    }
    
    func delete() {
        print("delete")
    }
}
