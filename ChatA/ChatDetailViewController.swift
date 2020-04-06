//
//  ChatDetailViewController.swift
//  ChatA
//
//  Created by Philippe Faurie on 4/5/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import UIKit

class ChatDetailViewController: UIViewController {

    
    @IBOutlet weak var msgNumber: UILabel!
    
    @IBOutlet weak var user1: UILabel!
    @IBOutlet weak var user2: UILabel!
    
    @IBOutlet weak var msgNum1: UILabel!
    @IBOutlet weak var msgNum2: UILabel!
    
    @IBOutlet weak var totalLen1: UILabel!
    @IBOutlet weak var totalLen2: UILabel!
    
    @IBOutlet weak var mediaNum1: UILabel!
    @IBOutlet weak var mediaNum2: UILabel!
    
    @IBOutlet weak var initiatorNum1: UILabel!
    @IBOutlet weak var initiatorNum2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setValues()
    }
    
    func setValues (){
        
        userL.sort(by: { ($0.msgNumber > $1.msgNumber) })
        
        msgNumber.text = String (chatL.count)
        user1.text = userL[0].name
        user2.text = userL[1].name
        
        msgNum1.text = String (userL[0].msgNumber)
        msgNum2.text = String (userL[1].msgNumber)
        
        totalLen1.text = String (format:"%.0f", userL[0].totalLen/Double(userL[0].msgNumber))
        totalLen2.text = String (format:"%.0f", userL[1].totalLen/Double(userL[1].msgNumber))

        mediaNum1.text = String (userL[0].mediaNumber)
        mediaNum2.text = String (userL[1].mediaNumber)

        initiatorNum1.text = String (userL[0].initiatorCount)
        initiatorNum2.text = String (userL[1].initiatorCount)

     

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
