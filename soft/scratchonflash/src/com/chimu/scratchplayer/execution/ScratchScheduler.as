package com.chimu.scratchplayer.execution {
    import com.chimu.scratchplayer.objects.StageMorph;
    
    
/**
 * The ScratchScheduler knows how to 
 * run all the processes that are currently active
 * and is the owner of that current list.
 * 
 * Originally this code was in the Stage, but
 * it is cleanly separable from the stage, so
 * it seemed worth pulling it out into its 
 * own class.  Somewhat closures the 'execution'
 * package.
 */
public class ScratchScheduler {
    protected var my_inProcessStep : Boolean = false;
    protected var my_processes : Array = new Array();
    protected var my_stage : StageMorph;
    
    
    public function initStage(stage : StageMorph) : ScratchScheduler {
        my_stage = stage;
        
        return this;
    }
    
    public function startProcessForStatements(blockList : Array) : ScratchProcess {
        var newProc : ScratchProcess = new ScratchProcess();
        newProc.initExpression(blockList);
        
        my_processes.push(newProc);
        
        return newProc;
    }
    
    
    public function getStage() : StageMorph {
        return my_stage;
    }
    
    /**
     * Step all the active processes
     */
    public function stepProcesses() : void {
        if (my_inProcessStep) return;
        
        my_inProcessStep = true;
        
        var processesToRun : Array = getProcessesToRun();
        for each (var p : ScratchProcess in processesToRun) {
            p.runStepFor(this);
        }
        
        my_processes = my_processes.filter(function (p : ScratchProcess, index: int, array:Array) : Boolean {return p.isRunning() });
        
        my_inProcessStep = false;
    }
    
    protected function getProcessesToRun() : Array {
        return my_processes.slice();
    }
    
    /**
     * Step the actual sprites or something?
     */  
    public function step() : void {
        
    }
     
}

}