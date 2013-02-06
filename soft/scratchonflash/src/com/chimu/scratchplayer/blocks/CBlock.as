package com.chimu.scratchplayer.blocks {
    

/**
 * A 'C'-shaped block with some number of items inside (e.g. loops)
 */
public class CBlock extends CommandBlock {
    public var nestedBlock : ScratchBlock;
    
    public function setFirstBlockList(aBlock : ScratchBlock) : void {
        nestedBlock = aBlock;
    }
    
    public override function isSpecialForm() : Boolean {
        return true;
    }
    
    public override function firstBlockList() : Array {
        if (nestedBlock == null) return [];
        return nestedBlock.getBlockSequence();
    }
    
    
    public override function printCodeOn_depth(buffer : Array, depth:int) : void {
        printCommandsAndArgsOn_depth(buffer, depth);

        if (nestedBlock != null) {
            nestedBlock.printCodeOn_depth(buffer, depth+1);
        }
        
        if (nextBlock != null) {
            nextBlock.printCodeOn_depth(buffer, depth);
        }
    } 

}

}