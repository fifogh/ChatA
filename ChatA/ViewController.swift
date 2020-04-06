//
//  ViewController.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/10/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import UIKit
import Foundation

import Zip


/*
var userL     : Array <User>      = Array()
var chatL     : Array <Chat>      = Array()
var blockL    : Array <Block>     = Array()
var chatFileL : Array <ChatFile>  = Array()
  
let fileManager = FileManager.default

let chatAnalyzer  = ChatAnalyzer ()
let userAnalyzer  = UserAnalyzer()
let blockAnalyzer = BlockAnalyzer()

*/

extension String
{
    func stringByReplacingFirstOccurrenceOfString(
            target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}



class ViewController: UIViewController {

    @IBOutlet weak var chatListTableView: UITableView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // read directory content to set chatFileL
      //  chatAnalyzer.getDirectory ()
        
        chatAnalyzer.listDocumentsDirectory ()

    }
    

    @IBAction func buttonPresse(_ sender: Any) {
        print ("Pressed")
        chatFileL.removeAll()
        chatAnalyzer.listDocumentsDirectory ()
    }
    
    
    
    func newZipArrived ( url: URL ){
         print ("New Zip")

        chatFileL.removeAll()
        chatAnalyzer.listDocumentsDirectory()
        chatListTableView.reloadData()
        
    }
}


//------------------------------------------------------------------------
// TABLEVIEW DELEGATE
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellChatFileId") as? ChatFileTableViewCell
        
        // Date to String
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        let dateStr = df.string(from: chatFileL[indexPath.row].date)
         
        // Cell's members display
        cell!.date!.text = dateStr
        
        var name = chatFileL[indexPath.row].name.replacingOccurrences(of: "WhatsApp Chat - ", with: "")
        name = name.replacingOccurrences(of: ".zip", with: "")
        cell!.label!.text = name
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatFileL.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath , animated: true)
        
        let url = chatFileL[indexPath.row].url
        if (chatAnalyzer.getChat (theUrl: url) == true ){
            print (" Success Extraction")
        } else {
            print (" failed Extraction")
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        
                chatFileL [indexPath.row].remove()                      // remove file in documents
                chatFileL.remove(at: indexPath.row)                     // remove from the table
                tableView.deleteRows(at: [indexPath], with: .fade)      // remove entry in tableView
    
        }
    }
}
