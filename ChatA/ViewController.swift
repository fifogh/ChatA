//
//  ViewController.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/10/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import UIKit
import Foundation

var chatL    : Array<Chat>   = Array()
var timeDiff : Array<Double> = Array()
var memberList = MemberL ()

let chatAnalyzer = ChatAnalyzer()

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

class Member {
    var name : String
    var msgNumber : Int
    var msgLen: [Int]
    var totalLen: Double
    var mediaNumber : Int

    
    init ( theName:String ) {
        name = theName
        msgNumber = 1
        msgLen = [Int]()
        totalLen = 0
        mediaNumber = 0;
    }
}

class MemberL {
    var  memberL : [Member]
    
    init () {
        memberL = Array()
    }
    
    
    func giveMember (theName: String) -> Member {
        
        var returnMember : Member
        if let member = memberL.first(where: {$0.name == theName}) {
            returnMember = member
        
        } else {
           //item could not be found
            returnMember = Member (theName: theName )
            memberL.append ( returnMember )
        }
        return(returnMember)
    }
    
    func addMember (theName: String) {
        let newMember = Member (theName: theName )
        memberL.append ( newMember )
    }
}

class Chat {
    var dateStr  : String
    var date     : Date
    var name     : String
    var msg      : String
    var timeDiff : Double

    
    init (theDateStr:String, theDate: Date, theName:String, theMsg: String){
        dateStr  = theDateStr
        date     = theDate
        name     = theName
        msg      = theMsg
        timeDiff = 0
    }
    
    func containMedia () -> Bool {
        if ( msg.contains("\u{200e}")) {
        //if ( msg.contains("\u{1f923}")) {
            print (msg)
            return (true)
            
            } else {
            return (false)
        }
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPresse(_ sender: Any) {

       readfile(theChatFile: "chat")
       setTimeDiff()
       printChat()
    }
  
    func getTimeDiff ( from: Chat, to: Chat) -> Double {
        return diffDate (date1: from.dateStr, date2: to.dateStr)
    }
    
    func setTimeDiff (){
        
        var first = true
        var prevChat = Chat (theDateStr: "", theDate:Date(), theName: "", theMsg: "")
        
        for chat in chatL{
            if (first == false){
                chat.timeDiff = getTimeDiff ( from: prevChat, to: chat)
            } else {
                first = false
            }
            prevChat = chat
        }
    }
    
    
    func readfile(theChatFile: String){
       if let filepath = Bundle.main.path(forResource: theChatFile, ofType: "txt") {
           do {
               let contents = try String(contentsOfFile: filepath)
               let array = contents.components(separatedBy: "\r\n")
               print (array.count)
            
               for elem in array {
                 if elem.count != 0 {
                    
                    // add Chat
                    let (dateStr, date, name, msg) = parse (toParse :elem)
                    let chat = Chat (theDateStr: dateStr, theDate: date, theName: name, theMsg: msg)
                    chatL.append (chat)
                    
                    // get Member
                    let member = memberList.giveMember (theName: name)
                    member.msgNumber += 1
                    member.totalLen += Double(msg.count)
                    
                    // checkMedia
                    if chat.containMedia(){
                        member.mediaNumber += 1
                    }
                 }
               }
            
           } catch {
               // contents could not be loaded
               print("No Content")
           }
       } else {
            // example.txt not found!
            print("file Not Found")
       }
    }
       
    func printChat () {
      /*  for elem in chatL{
            print ("timediff=")
            print(elem.timeDiff)
        }
      */
        for elem in memberList.memberL {
            let str = elem.name + " number: \(elem.msgNumber)" + " total: \(elem.totalLen)" + " mdeiaNumber : \(elem.mediaNumber)"
            print (str)
        }
        
        chatAnalyzer.printChat()
    }

    func parse (toParse :String) -> (String, Date, String, String){
        
        // toParse = [<Date>] <name>: <mag>
        let endDateIndex  = toParse.firstIndex(of: "]")!
        let dateSubstr    = toParse[...endDateIndex]
        
        //Date
        var dateStr = String (dateSubstr)
        dateStr     = dateStr.replacingOccurrences(of: "[", with: "")
        dateStr     = dateStr.replacingOccurrences(of: "]", with: "")
        dateStr     = dateStr.replacingOccurrences(of: ",", with: "")
        let date    = getDate(theDate: dateStr)
        

        // Rest : Name and Msg
        let restSubstr   = toParse[endDateIndex...]
        let rest         = String(restSubstr)
       
        //name
        let endNameIndex = rest.firstIndex(of: ":")!
        let nameSubstr   = rest[...endNameIndex]
        
        var nameStr      = String (nameSubstr)
        nameStr          = nameStr.replacingOccurrences(of: "]", with: "")
        nameStr          = nameStr.replacingOccurrences(of: ":", with: "")

        //msg
        let msgSubstr = rest[endNameIndex...]
        var msgStr    = String (msgSubstr)
        msgStr        = msgStr.stringByReplacingFirstOccurrenceOfString(target:":", withString: "")
        
        return (dateStr, date, nameStr, msgStr)
 
    }
    
    func getDate ( theDate: String ) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
                     
        formatter.dateFormat = "MM/dd/yy hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let date = formatter.date(from:theDate)!
        return (date)
    }
    
    
    func diffDate (date1: String, date2: String) -> Double {
        
        var elapsed : Double
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
              
        formatter.dateFormat = "MM/dd/yy hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
              
        let theDate1 = formatter.date(from:date1)
        let theDate2 = formatter.date(from:date2)
        elapsed = theDate2!.timeIntervalSince(theDate1!)
         
        return (elapsed)
        
    }
}
