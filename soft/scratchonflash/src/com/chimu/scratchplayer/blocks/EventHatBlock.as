package com.chimu.scratchplayer.blocks {
    import com.chimu.scratchplayer.execution.ScratchEvent;
    import com.chimu.scratchplayer.execution.ScratchProcess;
    

public class EventHatBlock extends HatBlock {


    static public const CONST_GenericEvent : String = "Scratch-GenericEvent";
    static public const CONST_StartClickedEvent : String = "Scratch-StartClicked";
    static public const CONST_MouseClickEvent : String = "Scratch-MouseClickEvent";
    static public const CONST_KeyPressedEvent : String = "Scratch-KeyPressedEvent";

    /**
     * Starts the process and registers it
     */
    public function startForEvent(event : ScratchEvent) : ScratchProcess {
        //non-key events stop (and restart) currently running processes, if any
        if (event.type != CONST_KeyPressedEvent) {
            if (scratchProc != null) {
                stop();
            } 
        }
        
        if (isRunning()) return null;
        if (scriptOwner == null) return null;
        if (getStage() == null) return null;
        
       
        return getStage().startProcessForStatements(getBlockSequence_SkipFirst());
    }
    
    
}

}