//
//  Blocks.swift
//  ChatA
//
//  Created by Philippe Faurie on 3/24/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import Foundation

var BlockL : Array <Block> = Array()

class Block {
    
    var fromIndex : Int
    var toIndex   : Int
    var initiator : String
    
    init (){
        fromIndex = 0;
        toIndex   = 0;
        initiator = ""
    }
    
}
