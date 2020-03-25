//
//  Member.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/25/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import Foundation

class Member {
    var name        : String
    var msgNumber   : Int
    //var msgLen      : [Int]
    var totalLen    : Double
    var mediaNumber : Int

    
    init ( theName:String ) {
        name        = theName
        msgNumber   = 1
      //  msgLen      = [Int]()
        totalLen    = 0
        mediaNumber = 0;
    }
}


class MemberAnalyzer {
/*
 var  memberL : [Member]
    
    init () {
        memberL = Array()
    }
*/
    //---------------------------------------------------------------
    // func giveMember
    //      return member in list if found create it if not found
    
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
    
    
    func createList () {
        
        for chat in chatL {
           // let member = memberList.giveMember (theName: chat.name)
            let member = memberAnalyzer.giveMember (theName: chat.name)

            // first stats on member
            member.msgNumber += 1
            member.totalLen += Double(chat.msg.count)
            
            if chat.containMedia(){
                member.mediaNumber += 1
            }
            
        }
    }
}

