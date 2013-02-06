package com.chimu.scratchplayer.blocks {

/**
 */
public class IfElseBlock extends CommandBlock {
    public var isBoolean : Boolean;
    
    public var trueBlock : ScratchBlock;
    public var falseBlock : ScratchBlock;
    
    
    public function setTrueBlock(aBlock : ScratchBlock) : void {
        trueBlock = aBlock;
    }
    
    public function setFalseBlock(aBlock : ScratchBlock) : void {
        falseBlock = aBlock;
    }
    
    public function trueBlockList() : Array {
        if (trueBlock == null) return [];
        return trueBlock.getBlockSequence();
    }
    
    public function falseBlockList() : Array {
        if (falseBlock == null) return [];
        return falseBlock.getBlockSequence();
    }
    
    
    
}

}