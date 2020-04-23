//
//  User.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/25/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import Foundation

class User {
    var name           : String
    var msgNumber      : Int
    //var msgLen       : [Int]
    var totalLen       : Double
    var mediaNumber    : Int
    var initiatorCount : Int
    var emojiCount     : Int


    
    init ( theName:String ) {
        self.name            = theName
        self.msgNumber       = 1
      //  msgLen        = [Int]()
        self.totalLen        = 0
        self.mediaNumber     = 0;
        self.initiatorCount  = 0;
        self.emojiCount      = 0;
    }
}


class UserAnalyzer {

    //---------------------------------------------------------------
    // func giveUser
    //      return member in list if found create it if not found
    
    func giveUser (theName: String) -> User {
        
        var returnUser : User
        if let user = userL.first(where: {$0.name == theName}) {
            returnUser = user
        
        } else {
           //item could not be found
            returnUser = User (theName: theName )
            userL.append ( returnUser )
        }
        return(returnUser)
    }
    
    func createList () {
        
        for chat in chatL {
           // let member = memberList.giveMember (theName: chat.name)
            let user = userAnalyzer.giveUser (theName: chat.name)

            // first stats on member
            user.msgNumber += 1
            user.totalLen += Double(chat.msg.count)
            
            if chat.containMedia(){
                user.mediaNumber += 1
            }
            
            user.emojiCount += chat.giveEmojiCount()
        }
    }
}

