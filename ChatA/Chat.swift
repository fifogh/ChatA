//
//  Chat.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/18/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import Foundation
import Zip


var userL     : Array <User>      = Array()
var chatL     : Array <Chat>      = Array()
var blockL    : Array <Block>     = Array()

var timeDiffL : Array <Int>       = Array()

var chatFileL : Array <ChatFile>  = Array()
  
let fileManager = FileManager.default

let chatAnalyzer  = ChatAnalyzer ()
let userAnalyzer  = UserAnalyzer()
let blockAnalyzer = BlockAnalyzer()

extension URL {
    var isDirectory: Bool {
        let values = try? resourceValues(forKeys: [.isDirectoryKey])
        return values?.isDirectory ?? false
    }
}

class ChatFile {
    
    var name : String
    var url  : URL
    var date : Date

    
    init (theName: String, theUrl: URL, theDate: Date){
        name  = theName
        url   = theUrl
        date  = theDate
        
        
        print (" url : \(url) is directory: \(url.isDirectory)")
    }
    

    func remove () {
        do {
            try fileManager.removeItem (at: url)
            print ("url deleted: \(url)")

            /*
            let noExtensionUrl = url.deletingPathExtension()                  // http://toto.txt -> http://toto
            let fileName       = noExtensionUrl.lastPathComponent + ".zip"    // http://toto     -> toto.zip
            

            let urlBase        = url.deletingLastPathComponent()
            let urlInbox       = urlBase.appendingPathComponent("Inbox")
            let urlToDel       = urlInbox.appendingPathComponent(fileName)

            do {
                try fileManager.removeItem (at: urlToDel)
                print ("in Box zipped file deleted \(urlToDel)")
            } catch {
                print ("cannot Delete InBox zipped file \(urlToDel)")
            }
            */
            
        } catch {
            print ("cannot remove url: \(url)")
        }
    }
}



class Chat {
    
    var dateStr  : String     // received converted in STR
    var date     : Date       // received real Date type
    var name     : String     // member
    var msg      : String     // msg full content
    var timeDiff : Double     // in secs with previous received msg
    var sameName : Bool       // true is previous name in chat is the same

    
    init (theDateStr:String, theDate: Date, theName:String, theMsg: String){
        dateStr  = theDateStr
        date     = theDate
        name     = theName
        msg      = theMsg
        timeDiff = 0
        sameName = false
    }
    
    
    //---------------------------------------------------------------
    // func emojiCount
    //      return how many emojis are in the msg
    func giveEmojiCount () -> Int {
    
        var count = 0
        for scalar in msg.unicodeScalars {

            switch scalar.value {
 
                case 0x1F600...0x1F64F, // Emoticons
                     0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                     0x1F680...0x1F6FF, // Transport and Map
                     0x2600...0x26FF,   // Misc symbols
                     0x2700...0x27BF,   // Dingbats
                     0xFE00...0xFE0F,   // Variation Selectors
                     0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                     0x1F1E6...0x1F1FF: // Flags
                    
                     count = count + 1
                
                default:
                     continue
            }
 
        }
        return (count)
    }
    
    //---------------------------------------------------------------
    // func containMedia
    //      return True is msg contain image or movie (even deleted)
    
    func containMedia () -> Bool {
        //if ( msg.contains("200e")) {
        if ( msg.contains("\u{200e}")) {
        //if ( msg.contains("\u{1f923}")) {
           // print (msg)
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
    
    //---------------------------------------------------------------
    // func subMsg
    //      return teh first x Char of the msg
    func subMsg ( len: Int )-> String{
        
        let len2 = min ( self.msg.count, len)

        return ( String( self.msg.prefix (len2)))
    }
    
    
}


class ChatAnalyzer {
    
    func printPad ( theString : String, level: Int) {
    
        var pad = "    "
        for _ in 0...level {
            pad = pad + "   "
        }
        
        let toPrint = pad + theString
        print(toPrint)
    }
    
    func addChatFile ( theChatUrl: URL ) {
        
        do {
            let attr = try fileManager.attributesOfItem(atPath: theChatUrl.path)
            let date = attr[FileAttributeKey.creationDate] as! Date
            let file = theChatUrl.lastPathComponent
            
            let chatFile = ChatFile ( theName: file, theUrl: theChatUrl, theDate: date )
            chatFileL.append ( chatFile )
        } catch {
            print ("cannot find date")
        }
    }
    
    
    func listDocumentsDirectory () {
           
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        listDirectory (thePathUrl: documentsUrl, level: 0, isInInbox: false)
    }
    
    func listDirectory (thePathUrl: URL, level: Int, isInInbox:Bool ) {
    
        printPad (theString : "ls on : \(thePathUrl.lastPathComponent)" , level:level)
       // var currentDirectory : String = ""
        
         do {
            let items = try fileManager.contentsOfDirectory(at: thePathUrl, includingPropertiesForKeys:nil )
            
            for urlFile in items {
                let file = urlFile.lastPathComponent
                let url = thePathUrl.appendingPathComponent(file)
                if (url.isDirectory == true ){
                   listDirectory (thePathUrl: url, level:level + 1, isInInbox: (file == "Inbox"))
  
                } else {
                    if (isInInbox == true ){
                        addChatFile (theChatUrl: url)
                    }
                   printPad (theString: url.lastPathComponent, level: level+2)
                }
           
            }
         } catch {
           print (" cannot access content of Directory \(thePathUrl): \(error.localizedDescription)")
        }
    }
  
    //---------------------------------------------------------------
    // func getDirectory
    //      read the Phone Document directory to set the chatFile List
    //      while doing so, delete the inbox directory (useless dupplication of received zip file

/*    func getDirectory () {
       
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let pathStr = documentsUrl.path
        
        var date: Date
   
        do {
        let items = try fileManager.contentsOfDirectory(atPath: pathStr)
             for file in items {
                print (file)
                let url = documentsUrl.appendingPathComponent(file)

                // special tratment for InBox sub directory
                // delete its content
                if (file == "Inbox") {
                 /*   let inboxPathStr = url.path
                    do{
                       let inboxItems = try fileManager.contentsOfDirectory(atPath: inboxPathStr)
                        for inboxFile in inboxItems {
                                                       
                           print ("inBox--> \(inboxFile)")
                           let urlToDel = url.appendingPathComponent(inboxFile)
                            // delete the unzipped file
                            do {
                              //  try fileManager.removeItem (at: urlToDel)
                                print ("in Box zipped file deleted \(urlToDel)")
                            } catch {
                                print ("cannot Delete InBox zipped file \(urlToDel)")
                            }
                        }
                    }catch{
                        print ("can t access inbox")
                    }
                  */
                } else {
                    // Normal case found a file, add it the chatFileL
                    do {
                        let attr = try fileManager.attributesOfItem(atPath: url.path)
                        date = attr[FileAttributeKey.creationDate] as! Date
                        let chatFile = ChatFile ( theName: file, theUrl: url, theDate: date )
                        chatFileL.append ( chatFile )
                    } catch {
                        print ("cannot find date")
                    }
                }
            }
        } catch {
            print ("empty Directory")
        }
    }
 */
    
    
    // reset the global list
    func resetAll () {
        chatL.removeAll()
        userL.removeAll()
        blockL.removeAll()
        timeDiffL.removeAll()
    }
    
    
    func getChat ( theUrl: URL) -> Bool {
    
        var ret = true
        resetAll()
        if (chatAnalyzer.chatExtract (theChatFile: theUrl) == true ){
                   
            chatAnalyzer.setDiffWithPrevious ()
            userAnalyzer.createList  ()
            
            blockAnalyzer.createBlockList()
            chatAnalyzer.printChat ()
                   
        } else {
            ret = false
        }
        
        return (ret)
    }
    
    
    //---------------------------------------------------------------
    // func chatExtract
    //      Create a chatList from exported file
    
    func chatExtract(theChatFile: URL)-> Bool{

        var unzipDirectory      : URL
        var directoryPathStr    : String
        var retValue = false
        
        do {
            unzipDirectory = try Zip.quickUnzipFile(theChatFile)
            do{
                directoryPathStr = unzipDirectory.path
                let items = try fileManager.contentsOfDirectory(atPath: directoryPathStr)
                
                // loop on items if several files in dir
                let pathURL = unzipDirectory.appendingPathComponent(items[0])
                do {
                    let contents = try String(contentsOf:pathURL)
                      
                    // get all content form unzipped file
                    splitContent(theContent:contents)
                    
                    // delete the unzipped file called -chat.txt
                    do {
                       try fileManager.removeItem (at: pathURL)
                       print ("unzipped file deleted: \(pathURL)")
                    } catch {
                        print ("cannot Delete Unzipped file")
                    }
                    retValue = true
                  } catch {
                print( "fail to convert to String")
                }
                
            } catch {
                   print( "fail to locate directory")
            }
                
        } catch {
            print ("Fail to unzip")
        }
        return(retValue)
    }
    
    func splitContent(theContent: String){
        let array = theContent.components(separatedBy: "\r\n")
        print (array.count)
        
        for elem in array {
            if elem.count != 0 {
                // add Chat
                let (valid, dateStr, date, name, msg) = parseLine (toParse :elem)
                if (valid == true){
                   let chat = Chat (theDateStr: dateStr, theDate: date, theName: name, theMsg: msg)
                   chatL.append (chat)
                }
        
             }
        }
    }
    

   //---------------------------------------------------------------
   // func parseLine
   //      Create a chatList from exported file

    func parseLine (toParse :String) -> (Bool, String, Date, String, String){
       
       // toParse = [<Date>] <name>: <msg>
        if let endDateIndex  = toParse.firstIndex(of: "]")  {
           let dateSubstr   = toParse[...endDateIndex]
        
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
          if let endNameIndex = rest.firstIndex(of: ":") {
             let nameSubstr   = rest[...endNameIndex]
       
             var nameStr      = String (nameSubstr)
             nameStr          = nameStr.replacingOccurrences(of: "]", with: "")
             nameStr          = nameStr.replacingOccurrences(of: ":", with: "")

             //msg
             let msgSubstr = rest[endNameIndex...]
             var msgStr    = String (msgSubstr)
             msgStr        = msgStr.stringByReplacingFirstOccurrenceOfString(target:":", withString: "")
        
             return (true, dateStr, date, nameStr, msgStr)
          }
        }
        
        return (false, "", Date(), "", "")

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
    // func setDiffWithPrevious
    //      for each Chat set how many sec after previous chat

    func setDiffWithPrevious (){
           
           var prevChat = Chat (theDateStr: "01/01/00 00:00:01 AM", theDate:Date(), theName: "", theMsg: "")
           var index = 0
        
          // var subMsg : String
 
           for chat in chatL{
              chat.timeDiff = chat.timeElapsed (fromDateStr: prevChat.dateStr)
              chat.sameName = (prevChat.name == chat.name)
              timeDiffL.append (Int(chat.timeDiff))
            
               prevChat = chat
 /*
             
        //    let len = min ( chat.msg.count, 25)
            
      //      subMsg = String( chat.msg.prefix (len))
            
         if ( chat.timeDiff > timeBetweenBlocks) {
                print ( "\(index) - elapsed: \(chat.timeDiff) ---<<<<  \(subMsg) ")
            } else {
                print ( "\(index) - elapsed: \(chat.timeDiff)")
            }
   */
             index = index + 1
           }
       }
    

    
    func printChat () {
        
        print ("Chat Numnber :")
        print (chatL.count)
        
        for elem in chatL{
            
            
            print ("msg: \(elem.date) - \(elem.name) - \(elem.msg)")
        }
        
        for elem in userL {
                   let str = elem.name + " number: \(elem.msgNumber)" + " total: \(elem.totalLen)" + " mdeiaNumber : \(elem.mediaNumber)"
                   print (str)
               }
        
        if let index = indexOfMsg ( dateStr: "11/2/19 7:12:00 AM") {
            let msg = chatL[index].msg 
            print (msg)
        }
        
       //  test()
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
