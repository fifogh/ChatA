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


var userL   : Array <User>  = Array()
var chatL   : Array <Chat>  = Array()
var blockL  : Array <Block> = Array()


let chatAnalyzer  = ChatAnalyzer ()
let userAnalyzer  = UserAnalyzer()
let blockAnalyzer = BlockAnalyzer()



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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPresse(_ sender: Any) {

        if (chatAnalyzer.chatExtract (theChatFile: "chat") == true ){
            
            chatAnalyzer.setTimeDiff ()
            userAnalyzer.createList  ()

            chatAnalyzer.printChat ()
            blockAnalyzer.createBlockList()
        } else {
            print (" failed Extraction")
        }

    }

}
