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
        if let view = segue.destination as? WaiterViewController {
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
        if #available(iOS 10.0, *) {
            let newWaiter = Waiter(context: managedContext)
            newWaiter.name = name
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

//extension ViewController: UITableViewDelegate {
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//}
