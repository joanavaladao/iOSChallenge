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
        if segue.identifier == "showWaiter" ||
            segue.identifier == "addWaiter",
            let view = segue.destination as? WaiterViewController {
            view.delegate = self
        }
    }
 
}

extension ViewController: WaiterDelegate {
    func addWaiter(_ name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext
//        let entity = NSEntityDescription.entity(forEntityName: "Waiter", in: managedContext)
//        let newWaiter = NSManagedObject(entity: entity!, insertInto: managedContext)
//        newWaiter.setValue(name, forKey: "name")
        if #available(iOS 10.0, *) {
            let newWaiter = Waiter(context: managedContext)
            newWaiter.name = name
//            waiters.append(newWaiter)
//            newWaiter.
            restaurant.addStaffObject(newWaiter)
            waiters.append(newWaiter)
            tableView.reloadData()
        } else {
            // Fallback on earlier versions
        }
        

        do {
            try managedContext.save()
        } catch {
            print("Failed to save")
        }

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

//extension RestaurantManager {
//
//    func save(_ name: String) {
//
//
//    }
//}
