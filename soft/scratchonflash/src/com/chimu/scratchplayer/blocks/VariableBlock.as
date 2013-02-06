package com.chimu.scratchplayer.blocks {
    import com.chimu.scratchplayer.objects.ScriptableScratchMorph;
    

/**
 * A VariableBlock produces a value from a variable binding.  The binding is simply the name of
 * the variable 'foo' and is stored in the selector.
 */
public class VariableBlock extends ReporterBlock {
    static public const CONST_VariableBlockTupleKey : String = "readVariable";
    
    public override function evaluateWithArgs(args : Array) : Object {
        //
        return receiver.getVariable(commandSpec);
    }
    
    public function initReceiver_spec(aReceiver : ScriptableScratchMorph, aSpec : String) : VariableBlock {
        receiver = aReceiver;
        my_commandSpec = aSpec;
        rebuildCommand();
        
        return this;
    }
    
    protected override function printCommandsAndArgsOn_depth(buffer : Array, depth:int) : void {
        if (depth >= 0) {
            pushOn_depth_string(buffer, depth, "");
        } else {
            pushOn_depth_string(buffer, depth, "");
        }

        var parsedCommand : Array = parseCommandSpec(); 
        
        var argIndex : int = 0; 
        for each (var commandPiece:String in parsedCommand) {
            if (commandPiece.indexOf(CONST_CommandArg) >=0) {
                var arg:* = args[argIndex];
                argIndex++;
                if (arg == null) {
                    logInfo("Missing args in: "+my_commandSpec);
                } else {
                    arg.printCodeOn_depth(buffer, -1);
                }
            } else {
                pushOn_depth_string(buffer, -1, commandPiece);
            }
        }
        if (depth >= 0) {
            pushOn_depth_string(buffer, depth, "\n");
        } else {
            pushOn_depth_string(buffer, depth, "");
        }
    }
    
    
    public override function printCodeOn_depth(buffer : Array, depth:int) : void {
        printCommandsAndArgsOn_depth(buffer, depth);
        
        if (nextBlock != null) {
            nextBlock.printCodeOn_depth(buffer, depth);
        }
    } 
    
}

}