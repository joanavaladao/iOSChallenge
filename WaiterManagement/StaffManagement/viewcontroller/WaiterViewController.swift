//
//  WaiterViewController.swift
//  StaffManagement
//
//  Created by Joana Valadão Bittencourt on 2018-04-11.
//  Copyright © 2018 Derek Harasen. All rights reserved.
//

import UIKit

class WaiterViewController: UIViewController {

    var delegate: WaiterDelegate?
    var name: String?
    
    @IBOutlet weak var waiterName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
