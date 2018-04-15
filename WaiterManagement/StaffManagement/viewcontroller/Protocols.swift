//
//  Protocols.swift
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-11.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import Foundation

protocol WaiterDelegate {
    func addWaiter(_ name: String, shifts: [ShiftStructure])
    func deleteWaiter(_ name: String)
    func getName() -> String
    func getShifts() -> [ShiftStructure]
}


extension ViewController {
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? WaiterViewController {
            view.delegate = self
            if segue.identifier == "showWaiter" {
                view.isNewWaiter(false)
            } else {
                view.isNewWaiter(true)
            }
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            navigationBar.barStyle = UIBarStyle.black
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.navigationItem.title = "Waiters"
        }
    }
 
}

extension ViewController: WaiterDelegate {
    func addWaiter(_ name: String, shifts: [ShiftStructure]) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if #available(iOS 10.0, *) {
            let newWaiter = Waiter(context: managedContext)
            newWaiter.name = name
            
            for shift in shifts {
                let newShift = Shift(context: managedContext)
                newShift.id = shift.id! as NSNumber
                newShift.startTime = shift.start
                newShift.endTime = shift.end
                newWaiter.addShiftsObject(newShift)
            }
            
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
    
    @objc func deleteWaiter(_ name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext
        if #available(iOS 10.0, *) {
            let fetchRequest: NSFetchRequest<Waiter> = Waiter.fetchRequest() as! NSFetchRequest<Waiter>
            fetchRequest.predicate = NSPredicate.init(format: "name==\"\(name)\"")
            if let result = try? managedContext.fetch(fetchRequest) {
                for object in result {
                    managedContext.delete(object)
                }
                do {
                    try managedContext.save()
                } catch {
                    print ("There was an error")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func getName() -> String {
        if let index = self.tableView.indexPathForSelectedRow?.row {
            let waiter: Waiter = waiters[index] as! Waiter
            return waiter.name
        }
        return ""
    }
    
    func getShifts() -> [ShiftStructure] {
        var result: [ShiftStructure] = []
        if let index = self.tableView.indexPathForSelectedRow?.row {
            let waiter = waiters[index] as! Waiter
            
            for shift in waiter.shifts {
                if let shift = shift as? Shift {
                    result.append(ShiftStructure(id: shift.id as! Int, startDate: shift.startTime, endDate: shift.endTime))
                }
            }
        }
        return result
    }
}

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waiters.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "waiterCell", for:indexPath) as? WaiterTableViewCell {
            let waiter = waiters[indexPath.row] as! Waiter
            cell.nameLabel.text = waiter.name
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let waiter = waiters[indexPath.row] as! Waiter
        deleteWaiter(waiter.name)
        waiters.remove(at: indexPath.row)
        tableView.reloadData()
    }
}

extension Date {
    var localizedDescription: String {
        return description(with: .current)
    }
}


