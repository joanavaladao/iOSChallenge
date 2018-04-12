//
//  Protocols.swift
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-11.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import Foundation

protocol WaiterDelegate {
    func addWaiter(_ name: String)
    func deleteWaiter(_ name: String)
    func getName() -> String
}


extension ViewController {
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWaiter",
            let view = segue.destination as? WaiterViewController {
            view.delegate = self
        }
    }
 
}

extension ViewController: WaiterDelegate {
    func addWaiter(_ name: String) {
        print("add")
    }
    
    func deleteWaiter(_ name: String) {
        print("delete")
    }
    
    func getName() -> String {
        if let index = self.tableView.indexPathForSelectedRow?.row {
            let waiter: Waiter = waiters[index] as! Waiter
            return waiter.name
        }
        return ""
    }
    
    
}
