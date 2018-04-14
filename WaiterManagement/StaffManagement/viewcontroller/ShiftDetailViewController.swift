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
    func show()
    func update()
    func delete()
}

class ShiftDetailViewController: UIViewController, UITextFieldDelegate {

    var delegate: ShiftDataDelegate?
    
    @IBOutlet weak var startShiftTextField: UITextField!
    @IBOutlet weak var endShiftTextField: UITextField!
    
    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startShiftTextField.delegate = self
        endShiftTextField.delegate = self
    }

    private func createDatePicker(_ sender: UITextField, hasToolbar: Bool = true) {
        // Toolbar
//        if hasToolbar {
//            let toolBar = UIToolbar()
//            toolBar.barStyle = .default
//            toolBar.isTranslucent = true
//            toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
//            toolBar.sizeToFit()
//
//            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick(sender:)))
//            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//            toolBar.setItems([spaceButton, doneButton], animated: true)
//            toolBar.isUserInteractionEnabled = true
//            sender.inputAccessoryView = toolBar
//        }
        
        // DatePicker
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView.minuteInterval = 30
        datePickerView.backgroundColor = .white
        datePickerView.locale = .current
        sender.inputView = datePickerView
        switch sender {
        case startShiftTextField:
            datePickerView.addTarget(self, action: #selector(handleStartDate(sender:)), for: UIControlEvents.valueChanged)
        case endShiftTextField:
            datePickerView.addTarget(self, action: #selector(handleEndDate(sender:)), for: UIControlEvents.valueChanged)
        default:
            print("error")
        }            
    }
    
    @objc func handleStartDate(sender: UIDatePicker) {
        startDate = handleDatePicker(sender: sender, textField: startShiftTextField)
    }

    @objc func handleEndDate(sender: UIDatePicker) {
        endDate = handleDatePicker(sender: sender, textField: endShiftTextField)
    }
    
    @objc func doneClick(sender: UIDatePicker) {
        print(handleDatePicker(sender: sender, textField: startShiftTextField))
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        createDatePicker(textField)
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Action
    @IBAction func saveShift(_ sender: UIButton) {
        if validateShift(),
            let startDate = startDate,
            let endDate = endDate {
            delegate?.addShift(start: startDate, end: endDate)
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.showShiftList()
        }
    }
    
    // MARK: Private functions
    private func handleDatePicker(sender: UIDatePicker, textField: UITextField) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        textField.text = dateFormatter.string(from: sender.date)
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
    
    func show() {
        
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
}

extension Date {
    var localizedDescription: String {
        return description(with: .current)
    }
}
