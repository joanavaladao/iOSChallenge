//
//  ShiftDetailViewController.swift
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-14.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import UIKit

protocol ShiftDetailDelegate {
    func setDelegate(_ delegate: ShiftDataDelegate)
}

class ShiftDetailViewController: UIViewController, UITextFieldDelegate {

    var delegate: ShiftDataDelegate?
    
    @IBOutlet weak var tableview: UITableView!
    
    var id: Int?
    var startDate: Date?
    var endDate: Date?
    var visiblePicker: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    @objc func handleStartDate(sender: UIDatePicker) {
        print("start: \(sender.tag)")
        if sender.tag == 1 {
            let date = handleDatePicker(sender: sender)
            startDate = date.truncateSecond()
            tableview.reloadData()
        }
    }

    @objc func handleEndDate(sender: UIDatePicker) {
        print("end: \(sender.tag)")
        if sender.tag == 3 {
            let date = handleDatePicker(sender: sender)
            endDate = date.truncateSecond()
            tableview.reloadData()
        }
    }
    
    // MARK: Action
    func addShift(sender: UIButton) {
        if validateShift(),
            let startDate = startDate,
            let endDate = endDate {
            delegate?.addShift(id: id, start: startDate, end: endDate)
        } else {
            let alert = UIAlertController(title: "Invalid Shift",
                                          message: "There are invalid shifts on your list. Please be sure that end date is bigger than the start date, and that there is no intersection with other shifts registered.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    func cancelShift(sender: UIButton) {
        if let delegate = self.delegate {
            delegate.showShiftList()
        }
    }

    // MARK: Private functions
    private func handleDatePicker(sender: UIDatePicker) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return sender.date
    }

    private func validateShift() -> Bool{
        if let startDate = startDate,
            let endDate = endDate,
            endDate > startDate {
            return true
        } else {
            print("datas invalidas")
        }
        return false
    }
}

extension ShiftDetailViewController: ShiftDetailDelegate {
    func setDelegate(_ delegate: ShiftDataDelegate) {
        self.delegate = delegate
    }
}

extension ShiftDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let index = indexPath.row
            if index%2 == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for:indexPath) as? DateTableViewCell {
                    if index == 0 {
                        cell.lineLabel.text = "Starts"
                        cell.dateLabel.text = startDate?.formatDate()
                    } else if index == 2 {
                        cell.lineLabel.text = "Ends"
                        cell.dateLabel.text = endDate?.formatDate()
                    }
                    return cell
                }
                return DateTableViewCell()
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as? PickerDateTableViewCell {
                    cell.pickerDate.tag = indexPath.row
                    cell.pickerDate.datePickerMode = .dateAndTime
                    cell.pickerDate.backgroundColor = .white
                    cell.pickerDate.locale = .current
                    if index == 1 {
                        cell.pickerDate.addTarget(self, action: #selector(handleStartDate(sender:)), for: UIControlEvents.valueChanged)
                    } else {
                        cell.pickerDate.addTarget(self, action: #selector(handleEndDate(sender:)), for: UIControlEvents.valueChanged)
                    }
                    return cell
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "buttonsCell", for: indexPath) as? TwoButtonsTableViewCell {
                cell.addButton.tag = indexPath.row
                cell.cancelButton.tag = indexPath.row
                cell.addButton.addTarget(self, action: #selector(addShift(sender:)), for: .touchUpInside)
                cell.cancelButton.addTarget(self, action: #selector(cancelShift(sender:)), for: .touchUpInside)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if  index == 0 || index == 2 {
            return 44
        } else if index == visiblePicker {
            return 164
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index == 0 {
            visiblePicker = visiblePicker == 1 ? 0 : 1
        } else if index == 2 {
            visiblePicker = visiblePicker == 3 ? 0 : 3
        }
        tableview.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Choose the shift"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "System", size: 14.0), size: 14.0)
        }
    }
}


