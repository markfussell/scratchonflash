package com.chimu.scratchplayer.blocks  {
    

/**
 * An argument to a Command Block -- but effectively
 * a Block on its own (just with a really simple result).
 * 
 * 
 */
public class ArgBlock extends ScratchBlock {
    public var value : * = null;
    
    public override function isSelfEvaluating() : Boolean {
        return true;
    }

    public override function evaluate() : * {
        return value;
    }

    
    public function setValue(aValue : *) : void {
        value = aValue;
    }


    //=====================================
    //=====================================
    //=====================================

    public override function printCodeOn_depth(buffer : Array, depth:int) : void {
        if (depth >= 0) {
            pushOn_depth_string(buffer, depth, ""+value+"\n");
        } else {
            if (value is Number) {
                pushOn_depth_string(buffer, depth, ""+value+"");
            } else {
                pushOn_depth_string(buffer, depth, "'"+value+"'");
            }
        }
        
        if (nextBlock != null) {
            nextBlock.printCodeOn_depth(buffer, depth);
        }
    } 
    
}

}