//
//  Chat.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/18/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import Foundation


class Chat {
    
    var dateStr  : String     // received converted in STR
    var date     : Date       // received real Date type
    var name     : String     // member
    var msg      : String     // msg full content
    var timeDiff : Double     // in secs with previous received msg

    
    init (theDateStr:String, theDate: Date, theName:String, theMsg: String){
        dateStr  = theDateStr
        date     = theDate
        name     = theName
        msg      = theMsg
        timeDiff = 0
    }
    
    
    //---------------------------------------------------------------
    // func containMedia
    //      return True is msg contain image or movie (even deleted)
    
    func containMedia () -> Bool {
        if ( msg.contains("\u{200e}")) {
        //if ( msg.contains("\u{1f923}")) {
            print (msg)
            return (true)
            
            } else {
            return (false)
        }
    }

    
    //---------------------------------------------------------------
    // func timeElapsed
    //      return sec elapsed between current msg and paramter date

    func timeElapsed (fromDateStr: String) -> Double {
    
    var elapsed : Double
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
          
    formatter.dateFormat = "MM/dd/yy hh:mm:ss a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
     
    let theDate1 = formatter.date(from:fromDateStr)
    let theDate2 = formatter.date(from:dateStr)
   
    elapsed = theDate2!.timeIntervalSince(theDate1!)
     
    return (elapsed)
    }
    
}


class ChatAnalyzer {
    
    //---------------------------------------------------------------
    // func chatExtract
    //      Create a chatList from exported file
    
    func chatExtract(theChatFile: String){
        
       if let filepath = Bundle.main.path(forResource: theChatFile, ofType: "txt") {
           do {
               let contents = try String(contentsOfFile: filepath)
               let array = contents.components(separatedBy: "\r\n")
               print (array.count)
            
               for elem in array {
                 if elem.count != 0 {
                    
                    // add Chat
                    let (dateStr, date, name, msg) = parseLine (toParse :elem)
                    let chat = Chat (theDateStr: dateStr, theDate: date, theName: name, theMsg: msg)
                    chatL.append (chat)
            
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
    

   //---------------------------------------------------------------
   // func parseLine
   //      Create a chatList from exported file

    func parseLine (toParse :String) -> (String, Date, String, String){
       
       // toParse = [<Date>] <name>: <msg>
       let endDateIndex  = toParse.firstIndex(of: "]")!
       let dateSubstr    = toParse[...endDateIndex]
       
       //Date
       var dateStr = String (dateSubstr)
       dateStr     = dateStr.replacingOccurrences(of: "[", with: "")
       dateStr     = dateStr.replacingOccurrences(of: "]", with: "")
       dateStr     = dateStr.replacingOccurrences(of: ",", with: "")
       let date    = realDate(theDate: dateStr)
       

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
   
    
   //---------------------------------------------------------------
   // func realDate
   //      transform StringDate into a date (type Date)

   func realDate ( theDate: String ) -> Date {
       let formatter = DateFormatter()
       formatter.locale = Locale(identifier: "en_US_POSIX")
                    
       formatter.dateFormat = "MM/dd/yy hh:mm:ss a"
       formatter.amSymbol = "AM"
       formatter.pmSymbol = "PM"
       let date = formatter.date(from:theDate)!
       return (date)
   }
   
    
    //---------------------------------------------------------------
    // func setTimeDiff
    //      for each Chat set how many sec after previous chat

    func setTimeDiff (){
           
           var prevChat = Chat (theDateStr: "01/01/00 00:00:01 AM", theDate:Date(), theName: "", theMsg: "")
           
           for chat in chatL{
             chat.timeDiff = chat.timeElapsed (fromDateStr: prevChat.dateStr)
             prevChat = chat
           }
       }
    
    
    
    func printChat () {
        
        print ("Chat Numnber :")
        print (chatL.count)
        
        for elem in memberL {
                   let str = elem.name + " number: \(elem.msgNumber)" + " total: \(elem.totalLen)" + " mdeiaNumber : \(elem.mediaNumber)"
                   print (str)
               }
        
        if let index = indexOfMsg ( dateStr: "11/2/19 7:12:00 AM") {
            let msg = chatL[index].msg 
            print (msg)
        }
        
         test()
    }
    
    
    
    // return the index of a chat in ChatL by searching Date
   func indexOfMsg (dateStr: String) -> Int?{
        
        return (chatL.firstIndex(where: { $0.dateStr == dateStr  }) ?? nil)
        
    }
    
  // /*
   func test () {
        
        let fromDate = indexOfMsg ( dateStr: "10/28/19 3:59:31 PM")
        let toDate   = indexOfMsg ( dateStr: "11/2/19 12:39:44 AM")
        let subChatL = chatL [fromDate!...toDate!]
        
        for elem in subChatL {
            print (elem.msg)
        }
        
    }
   // */
}
