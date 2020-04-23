//
//  ChatDetailViewController.swift
//  ChatA
//
//  Created by Philippe Faurie on 4/5/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import UIKit

class ChatDetailViewController: UIViewController {
    
  
    @IBOutlet weak var detailChatTableView: UITableView!
    
    var  chatName :String = ""
    
    let labelL = [ "Message #", "Average Length", "Media #", "initiator", "Emoji #"]
    
    let labelEmojiL = ["🧮", "✍️", "🎥", "👋", "😀" ]
       //  🧭  ⏱
         

    
    @IBOutlet weak var msgNumber: UILabel!
    
    @IBOutlet weak var user1: UILabel!
    @IBOutlet weak var user2: UILabel!
    
    @IBOutlet weak var blockTotalNum: UILabel!
    @IBOutlet weak var timeBetweenShorts: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setValues()
        self.navigationItem.title = chatName
        
      
    }
    
    func setValues (){
        
        userL.sort(by: { ($0.msgNumber > $1.msgNumber) })
        
        msgNumber.text          = String (chatL.count)
        blockTotalNum.text      = String (blockL.count)
        timeBetweenShorts.text  = String (timeBetweenBlocks)
        
        user1.text = userL[0].name
        user2.text = userL[1].name

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

//------------------------------------------------------------------------
// TABLEVIEW DELEGATE
extension ChatDetailViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetailChatId") as? ChatDetailTableViewCell
        
        
       
        cell!.label!.text      = labelL[indexPath.row]
        cell!.labelEmoji!.text = labelEmojiL[indexPath.row]
        
        switch indexPath.row {
            
        case 0 :
            //message number
            cell!.counter1.text = String (userL[0].msgNumber)
            cell!.counter2.text = String (userL[1].msgNumber)
            
            
        case 1 :
            // average Length
            cell!.counter1.text = String (format:"%.0f", userL[0].totalLen/Double(userL[0].msgNumber))
            cell!.counter2.text = String (format:"%.0f", userL[1].totalLen/Double(userL[1].msgNumber))
            
        case 2 :
            // M<edia Number
            cell!.counter1.text = String (userL[0].mediaNumber)
            cell!.counter2.text = String (userL[1].mediaNumber)

        case 3 :
            // Initiator
            cell!.counter1.text = String (userL[0].initiatorCount)
            cell!.counter2.text = String (userL[1].initiatorCount)

        case 4 :
            // Initiator
            cell!.counter1.text = String (userL[0].emojiCount)
            cell!.counter2.text = String (userL[1].emojiCount)

        default :
            print ("error case table end")

        }

        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelL.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath , animated: true)
    }
}
