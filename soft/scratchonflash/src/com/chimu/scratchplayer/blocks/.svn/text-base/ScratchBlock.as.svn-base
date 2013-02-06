package com.chimu.scratchplayer.blocks {
    import com.chimu.scratchplayer.execution.ScratchEvent;
    import com.chimu.scratchplayer.execution.ScratchProcess;
    import com.chimu.scratchplayer.objects.ScratchObjectPack;
    import com.chimu.scratchplayer.objects.ScriptableScratchMorph;
    import com.chimu.scratchplayer.objects.StageMorph;
    

/**
 * A ScratchBlock is a BlockMorph without the Morph part:
 *    * It is static for the lifetime of the program
 *    * It is not-visually represented
 * 
 * Blocks are attached to their sprite
 */
public class ScratchBlock {
    
    /**
     * The currently running ScratchProcess for me
     */
    public var scratchProc : ScratchProcess;
    
    public var blockOwner : ScriptableScratchMorph;
    
    public var nextBlock : ScratchBlock;
    
    
    protected var my_isSpecialForm : Boolean = false;
    protected var my_isTimed : Boolean = false;
    
    //===========================================
    //=== Logging
    //===========================================
    
    protected function logInfo(info : String) : void {
        ScratchObjectPack.shared_outerApp.logInfo(info);
    }
    

    //===========================================
    //=== 
    //===========================================
    
    public function setBlockType(blockType : String) : void {
        if (blockType == "s") {
            my_isSpecialForm = true;
        } else if (blockType == "t") {
            my_isTimed = true;
        }
    }

    public function setupOwner(aMorph : ScriptableScratchMorph) : void {
        blockOwner = aMorph;
    }
    
    public function getBlockSequence() : Array {
        var result : Array = new Array();
        
        var current : ScratchBlock = this;
        while (current != null) {
            result.push(current);
            current = current.nextBlock;
        }
        
        return result;
    }
    
    public function getBlockSequence_SkipFirst() : Array {
        var result : Array = new Array();
        
        var current : ScratchBlock = this.nextBlock;
        while (current != null) {
            result.push(current);
            current = current.nextBlock;
        }
        
        return result;
    }
    
    public function getStage() : StageMorph {
        if (blockOwner == null) return null;
        
        return blockOwner.getStage();
    }
    
    public function getArgumentCount() : int {
        return 0;
    }
    
    //===========================================
    //===========================================
    //===========================================

    //Evaluate without any context
    public function evaluate() : * {
        return null;
    }

    public function evaluateSpecialFormOn(process : ScratchProcess) : void {
        //Nada by default
    }
    
    //===========================================
    //===========================================
    //===========================================
    //MLF: There are several kinds of Blocks.
    //Instead of class-testing an object, simply let it 
    //answer the questions of its 'Kind' itself
    

    /**
     * SpecialForm commands talk to the ScratchProcess
     * itself instead of talking to the Sprite and Stage
     */
    public function isSpecialForm() : Boolean {
        return my_isSpecialForm;
    }
    
    public function isTimed() : Boolean {
        return my_isTimed;
    }

    //===========================================
    //===========================================
    //===========================================

    
    public function isCollection() : Boolean {
        return false;
    }

    public function isCommand() : Boolean {
        return false;
    }

    public function isComment() : Boolean {
        return false;
    }

    public function isSelfEvaluating() : Boolean {
        return false;
    }

    //===========================================
    //===========================================
    //===========================================

    public function respondsToEvent(event : ScratchEvent) : Boolean {
        return false;
    }
    
    public function respondsToKeyEvent(event : String) : Boolean {
        return false;
    }
    
    public function respondsToMouseEvents() : Boolean {
        return false;
    }
    
    public function respondsToCustomEvent(event : String) : Boolean {
        return false;
    }
    
    
    //public var scriptOwner : *;
    
    
    //Just a part of a CommandBlock
    //public function argumentAt(index : int) : * {
    //    return null;
    //}
    
    public function firstBlockList() : Array {
        return [];
    }
    
    public function isRunning() : Boolean {
        return scratchProc != null;
    }
    
    protected function clearProcess() : void {
        scratchProc = null;
    }
    
    protected function stop() : void {
        if (scratchProc == null) return;
        
        //self changed;
        scratchProc.stop();
        scratchProc = null;
    }
 
 
    //=====================================
    //=====================================
    //=====================================

    protected const CONST_LotsOfSpaces : String = "                                                    ";

    protected function pushOn_depth_string(buffer : Array, depth:int, txt:String) : void {
        if (depth > 0) {
            buffer.push(CONST_LotsOfSpaces.substr(0,depth*4), txt);
        } else {
            buffer.push(txt);
        }
    }

    public function printCodeOn_depth(buffer : Array, depth:int) : void {
        pushOn_depth_string(buffer, depth, "We are here\n");
        if (nextBlock != null) {
            nextBlock.printCodeOn_depth(buffer, depth);
        }
    } 
    
    
}

}