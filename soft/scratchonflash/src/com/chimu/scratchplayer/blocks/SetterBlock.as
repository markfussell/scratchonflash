package com.chimu.scratchplayer.blocks {
    import com.chimu.scratchplayer.objects.ScriptableScratchMorph;
    

/**
 */
public class SetterBlock extends CommandBlock {
    public var variable : String;
    
    
    public override function evaluateWithArgs(args : Array) : Object {
        if (my_evaluateFunction_cache == null) {
            cacheEvaluateFunction();
        }
        return my_evaluateFunction_cache.call(receiver, variable, args[0]);
    } 

    public function initReceiver_variable_selector_spec(aReceiver : ScriptableScratchMorph, aVariable : String, aSelector : String, aSpec : String) : SetterBlock {
        selector = aSelector;
        variable = aVariable;
        receiver = aReceiver;
        
        my_commandSpec = aSpec;
        rebuildCommand();
        
        return this;
    }
    
}

}