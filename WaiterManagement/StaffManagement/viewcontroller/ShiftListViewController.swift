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
    func show()
    func update()
    func delete()
}

class ShiftListViewController: UIViewController {

    var delegate: ShiftDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//TODO: implement functions
extension ShiftListViewController: ShiftListDelegate {
    
    func setDelegate(_ delegate: ShiftDataDelegate) {
        self.delegate = delegate
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
