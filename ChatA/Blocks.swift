//
//  Blocks.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/24/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import Foundation

var timeBetweenBlocks : Double = 150 // seconds

enum BlockType {
                    case fast
                    case slow
                }

class Block {
    
    var fromIndex : Int                 // in ChatL
    var toIndex   : Int                 // in ChatL
    var initiator : String              // User Name
    var blockType : BlockType           // slow or fast time difference of chat in the block

    
    init (fromIdx: Int, theInitiator: String, theBlockType: BlockType){
        fromIndex = fromIdx;
        toIndex   = fromIdx;
        initiator = theInitiator
        blockType = theBlockType
    }
    
    // return the index of a chat in ChatL by searching Date
    func indexOfMsg (dateStr: String) -> Int?{
         
         return (chatL.firstIndex(where: { $0.dateStr == dateStr  }) ?? nil)
         
     }
    
}

class BlockAnalyzer {

    //---------------------------------------------------------------
    // func createBlockList
    //      Parse chatL to create a succession of fast/slow blocks

    func createBlockList () {
                   
        var currBlock = Block(fromIdx: 0, theInitiator: chatL[0].name, theBlockType: .fast)
        
        // Statistical function to determine size of small block
        // Ie interactive chat as oppposed to large intervals between chats
        
        var reactionTimeL :[Int] = Array()
        var totalTime = 0
        
        // make subArray of timeDiffL with timediff between User change
        for (idx, timeDiff) in timeDiffL.enumerated () {
            
            if (chatL[idx].sameName == false ) {
                
                reactionTimeL.append (totalTime)
                totalTime = timeDiff
                
            } else {
                totalTime += timeDiff
            }
        }
        
        // use this array to determine short interaction vs other ( i.e. long)
        timeBetweenBlocks = getKMean (distances:reactionTimeL)

        
        // Create the blockL : list of alternative FastPace/LongPace Bocks
        for (idx, chat) in chatL.enumerated() {
            
            // A change of pace in messages will close previous block and start a new block
            // keep the same block if user does not change
            
            if ( ( ((currBlock.blockType == .fast ) && (chat.timeDiff > timeBetweenBlocks)) ||
                   ((currBlock.blockType == .slow ) && (chat.timeDiff <= timeBetweenBlocks)) )  &&
                   (chat.sameName == false) ) {
                
                // Close current BlocK
                blockL.append (currBlock)
                
                // Create new block
                // alternate the blockType
                let newBlockType : BlockType
                let initiator : String
                
                if ( currBlock.blockType == .fast ) {
                    newBlockType = .slow
                    initiator = chatL[idx].name      // the current one getting slow
                }else{
                    newBlockType = .fast
                    initiator = chatL[idx-1].name    // the previous one trigger a fast reaction
                }
                
                let newBlock = Block(fromIdx: idx, theInitiator: initiator, theBlockType: newBlockType)
                
                userAnalyzer.giveUser(theName: initiator).initiatorCount += 1
                currBlock = newBlock

            } else {
                // update the toIndex to current chatIndex
                currBlock.toIndex = idx
            }
            
        }
        
        // end of loop: Close current BlocK
        blockL.append (currBlock)

        printBlocks()
    }
    
    func printBlocks () {
           
        print ("number of Blocks :")
        print (blockL.count)
        
        for block in blockL {
            let str = "\(block.blockType) from: \(block.fromIndex) to:  \(block.toIndex) >>> \(chatL [block.toIndex].subMsg(len:300))"
            print (str)
        }
    }
}
