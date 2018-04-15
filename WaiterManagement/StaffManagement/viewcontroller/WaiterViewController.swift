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
    func addShift(id: Int?, start: Date, end: Date)
    func quantityOfShifts() -> Int
    func shiftAt(_ index: Int) -> ShiftStructure?
    func deleteShift()
}

struct ShiftStructure {
    var id: Int? = nil
    var start: Date
    var end: Date
    
    init(startDate: Date, endDate: Date) {
        id = nil
        start = startDate
        end = endDate
    }
    
    init(id: Int, startDate: Date, endDate: Date) {
        self.id = id
        start = startDate
        end = endDate
    }
}

class WaiterViewController: UIViewController {

    var delegate: WaiterDelegate?
    var name: String?
    var shiftList: ShiftListDelegate?
    var shiftDetail: ShiftDetailDelegate?
    var shifts: [ShiftStructure] = []
    
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
        if let shifts = delegate?.getShifts() {
            self.shifts = shifts
        }
        showShiftList()
    }
    
    @objc private func saveButton() {
        if let delegate = self.delegate,
            let name = waiterName.text {
            delegate.addWaiter(name, shifts: shifts)
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
    
    private func validaShift(shift1: ShiftStructure, shift2: ShiftStructure) -> Bool {
        if (shift1.start >= shift2.start && shift1.start < shift2.end) ||
            (shift1.end > shift2.start && shift1.end <= shift2.end) ||
            (shift2.start >= shift1.start && shift2.start < shift1.end) ||
            (shift2.end > shift1.start && shift2.end <= shift1.end) {
            return false
        }
        return true
    }
    
    func validaShift(start: Date, end: Date) -> Bool {
        if shifts.count > 0 {
            for shift in shifts {
                if !validaShift(shift1: shift, shift2: ShiftStructure(startDate: start, endDate: end)) {
                    return false
                }
            }
        }
        return true
    }
    
    func maxID() -> Int{
        let max = shifts.max(by: {(a, b) -> Bool in
            return a.id ?? 0 < b.id ?? 0
        })
        return max?.id ?? 0
    }
}

extension WaiterViewController: ShiftDataDelegate {
    func shiftAt(_ index: Int) -> ShiftStructure? {
        print("shifts: \(shifts.count), index: \(index)")
        if shifts.count > 0 && index < shifts.count {
            return shifts[index]
        }
        return nil
    }
    
    func quantityOfShifts() -> Int {
        return shifts.count
    }
    
    func showShiftList() {
        shiftDetailContainer.isHidden = true
        shiftListContainer.isHidden = false
    }
    
    func showShiftDetail() {
        shiftListContainer.isHidden = true
        shiftDetailContainer.isHidden = false
    }
    
    func addShift(id: Int?, start: Date, end: Date) {
        if validaShift(start: start, end: end) {
            let id = maxID()
            shifts.append(ShiftStructure(id: id+1, startDate: start, endDate: end))
            if let shiftList = shiftList {
                shiftList.reload()
            }
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
