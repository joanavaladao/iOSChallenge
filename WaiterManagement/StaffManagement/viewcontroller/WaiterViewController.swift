//
//  WaiterViewController.swift
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-11.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import UIKit

protocol ShiftDataDelegate {
    func showShiftList()
    func showShiftDetail()
    func addShift(start: Date, end: Date)
    func deleteShift()
}

struct Shift: Equatable {
    var start: Date
    var end: Date
}

class WaiterViewController: UIViewController {

    var delegate: WaiterDelegate?
    var name: String?
    var shiftList: ShiftListDelegate?
    var shiftDetail: ShiftDetailDelegate?
    var shifts: [Shift] = []
    
    @IBOutlet weak var waiterName: UITextField!
    @IBOutlet weak var shiftListContainer: UIView!
    @IBOutlet weak var shiftDetailContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
        showData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showData() {
        if let name = delegate?.getName() {
            waiterName.text = name
        }
        showShiftList()
    }
    
    @objc private func saveButton() {
        if let delegate = self.delegate,
            let name = waiterName.text {
            delegate.addWaiter(name)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Action
    @IBAction func addShift(_ sender: UIButton) {
        showShiftDetail()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ShiftListDelegate {
            self.shiftList = viewController
            self.shiftList?.setDelegate(self)
        } else if let viewController = segue.destination as? ShiftDetailDelegate {
            self.shiftDetail = viewController
            self.shiftDetail?.setDelegate(self)
        }
    }
    
    private func validaShift(shift1: Shift, shift2: Shift) -> Bool {
        if (shift1.start >= shift2.start && shift1.start < shift2.end) ||
            (shift1.end > shift2.start && shift1.end <= shift2.end) ||
            (shift2.start >= shift1.start && shift2.start < shift1.end) ||
            (shift2.end > shift1.start && shift2.end <= shift1.end) {
            return false
        }
        return true
    }
    
    func validaShift(start: Date, end: Date) -> Bool{
        if shifts.count > 0 {
            for shift in shifts {
                if !validaShift(shift1: shift, shift2: Shift(start: start, end: end)) {
                    return false
                }
            }
        }
        return true
    }
}

extension WaiterViewController: ShiftDataDelegate {  
    func showShiftList() {
        shiftDetailContainer.isHidden = true
        shiftListContainer.isHidden = false
    }
    
    func showShiftDetail() {
        shiftListContainer.isHidden = true
        shiftDetailContainer.isHidden = false
    }
    
    func addShift(start: Date, end: Date) {
        if validaShift(start: start, end: end) {
            shifts.append(Shift(start: start, end: end))
            showShiftList()
            print("***** SHIFTS: \(shifts)")
        } else {
            //TODO: show alert
            print("shift invalido")
        }
    }
    
    func deleteShift() {
        
    }
}
