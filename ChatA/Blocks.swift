//
//  Blocks.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/24/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import Foundation

let timeBetweenBlocks = 300.0  // seconds

class Block {
    
    var fromIndex : Int
    var toIndex   : Int
    var initiator : String

    
    init (fromIdx: Int, user: String){
        fromIndex = fromIdx;
        toIndex   = fromIdx;
        initiator = user
    }
    
    // return the index of a chat in ChatL by searching Date
    func indexOfMsg (dateStr: String) -> Int?{
         
         return (chatL.firstIndex(where: { $0.dateStr == dateStr  }) ?? nil)
         
     }
    
}

class BlockAnalyzer {

    func createBlockList () {
           
        var index = 0
        var prevBlock = Block(fromIdx: 0, user: chatL[0].name)
        
        for chat in chatL {
           if (chat.timeDiff > timeBetweenBlocks) && (index != 0) {
            
            // New block now
            // so store the current one and create a new one
            prevBlock.toIndex = index
            blockL.append ( prevBlock )
            
            // increment Initiator Number for teh user
            let user = userAnalyzer.giveUser (theName: chat.name )
            user.initiatorCount += 1

            let newBlock = Block(fromIdx: index, user: chat.name)
            prevBlock = newBlock
            
            }
            index = index + 1
        }
        
        //append the last one
        prevBlock.toIndex = index
        blockL.append ( prevBlock )
        
        
       // printBlocks()
    }
    
    func printBlocks () {
           
        print ("number of Blocks :")
        print (blockL.count)
        
        for block in blockL {
            let str = "from: \(block.fromIndex)" + "  to:  + \(block.toIndex) "
            print (str)
        }
    }
           
        
}
