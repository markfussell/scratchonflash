package com.chimu.scratchplayer.blocks {
    import com.chimu.scratchplayer.execution.ScratchEvent;
    import com.chimu.scratchplayer.objects.ScriptableScratchMorph;
    import com.chimu.scratchplayer.translation.ScratchTranslatorLib;
    

public class HatBlock extends ScratchBlock {
    public var scriptOwner : ScriptableScratchMorph;
    protected var my_parameters : *;

    protected var my_eventType : String;
    protected var my_eventName : String;
    
    
    public override function respondsToEvent(event : ScratchEvent) : Boolean {
        if (my_eventType != event.type) return false;
        if (my_eventName != event.name) return false;
        
        return true;
    }

    
    public override function respondsToKeyEvent(event : String) : Boolean {
        if (my_eventType != EventHatBlock.CONST_KeyPressedEvent) return false;
        
        return event == my_eventName;
    }

    
    public override function respondsToMouseEvents() : Boolean {
        if (my_eventType != EventHatBlock.CONST_MouseClickEvent) return false;

        return true;
    }

    
    public override function respondsToCustomEvent(event : String) : Boolean {
        return event == my_eventName;
    }

    
    public function initEventType_name(aType : String, aName : String) : HatBlock {
        my_eventType = aType;
        my_eventName = convertName(aName);
        
        return this;
    }  
    
    protected function convertName(aName : String) : String {
        if (my_eventType != EventHatBlock.CONST_KeyPressedEvent) return aName;
        
        return ScratchTranslatorLib.characterFromStCharName(aName);
    }

    public function start() : void {
        stop();
        if (scratchProc == null) {
            if (scriptOwner == null) return;
            if (getStage()) return;
            
            scratchProc = getStage().startProcessForStatements(this.getBlockSequence_SkipFirst());
            
            //self changed
        }
    }
    
    //=====================================
    //=====================================
    //=====================================

    public override function printCodeOn_depth(buffer : Array, depth:int) : void {
        pushOn_depth_string(buffer, depth, "when '"+my_eventName+"'\n");
        
        if (nextBlock != null) {
            nextBlock.printCodeOn_depth(buffer, depth);
        }
    } 
    
    
}

}