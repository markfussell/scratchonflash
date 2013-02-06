package com.chimu.scratchplayer.blocks {
    import com.chimu.scratchplayer.execution.ScratchProcess;
    import com.chimu.scratchplayer.objects.ScriptableScratchMorph;
    

public class CommandBlock extends ScratchBlock {
    protected var my_commandSpec : String;
    
    public var args : Array = new Array();
    
    public var receiver : ScriptableScratchMorph;
    public var selector : String;
    

    /**
     * The function to call on the target based upon the selector
     */
    protected var my_evaluateFunction_cache : Function;
    protected var my_evaluateSpecialFunction_cache : Function;
    
    
    //================================================
    //================================================
    //================================================
    
    
    public override function isCommand() : Boolean {
        return true;
    }

    public override function getArgumentCount() : int {
        return args.length;
    }
    
    
    public function getArgumentAt(index : int) : * {
        return args[index];
    }
    
    public function replaceArgBlock_by(oldBlock : ScratchBlock, newBlock : ScratchBlock) : void {
        for (var i : int = 0; i<args.length; i++) {
            if (args[i] == oldBlock) {
                args[i] = newBlock;
            }
        }
    }
    //==============================================================
    //==============================================================
    //==============================================================
    
    public override function evaluate() : * {
        return evaluateWithArgs(args);
    }

    public function evaluateWithArgs(someArgs : Array) : Object {
        if (my_evaluateFunction_cache == null) {
            cacheEvaluateFunction();
        }
        return my_evaluateFunction_cache.apply(receiver, someArgs);
    } 

    public override function evaluateSpecialFormOn(process : ScratchProcess) : void {
        if (my_evaluateSpecialFunction_cache == null) {
            cacheEvaluateSpecialFunction(process);
        }
        my_evaluateSpecialFunction_cache.apply(process,[]);
    }
    
    
    //======================
    //======================
    //======================

    
    protected function cacheEvaluateFunction() : void {
        my_evaluateFunction_cache = receiver.findEvaluateFor(selector);
    }


    protected function cacheEvaluateSpecialFunction(process : ScratchProcess) : void {
        my_evaluateSpecialFunction_cache = process.findEvaluateSpecialFor(selector);
    }


    //==============================================================
    //==============================================================
    //==============================================================

    protected function get commandSpec() : String {
        return my_commandSpec;
    }


    public function setupCommandSpec(newSpec : String) : void {
        my_commandSpec = newSpec;
        rebuildCommand();
    }


    /**
     * Rebuild the arguments of the CommandBlock 
     * after a change to the spec.
     * 
     * Note that this is more brutal than
     * the Squeak/Editor version because we
     * can't modify a Command after creating it
     * the first time.
     * 
     * Was: 'addLabel'
     */
    protected function rebuildCommand() : void {
        if (my_commandSpec == null) return;
        
        var saveNext : * = nextBlock;
        
        var tokens : Array = parseCommandSpec();
        var argTokens : Array = tokens.filter(function (eachEntry : String, index: int, array:Array) : Boolean {return (eachEntry.length == 2) && (eachEntry.charAt(0) == CONST_CommandArg)});
        
        args = new Array();
        for (var i:int = 0; i<argTokens.length; i++) {
            args.push(createArgBlockFor(argTokens[i]));
        }
        
        //We don't care about the labels
    }

    protected function createArgBlockFor(arg : String) : * {
        var code : String = arg.charAt(1);
        
        return new ArgBlock();
    }
    
    static protected const CONST_CommandArg : String = "%";
    protected function parseCommandSpec() : Array {
        var result : Array = new Array();
        var length : int = commandSpec.length;
        
        var i : int = 0;
        while (i < length) {
            var j : int = commandSpec.indexOf(CONST_CommandArg, i);
            if (j >= 0) {
                if (j > i) {
                    result.push(commandSpec.substring(i,j));
                }
                if (j < (length-1)) {
                    result.push(commandSpec.substr(j,2));
                } else {
                    result.push(CONST_CommandArg);
                }
                i=j+2;
            } else {
                result.push(commandSpec.substring(i,length));
                i = length + 1; //Terminates loop... could also break
            }
        }
        
        return result;
    }

    //=====================================
    //=====================================
    //=====================================

    protected function printCommandsAndArgsOn_depth(buffer : Array, depth:int) : void {
        if (depth >= 0) {
            pushOn_depth_string(buffer, depth, "");
        } else {
            pushOn_depth_string(buffer, depth, "(");
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
            pushOn_depth_string(buffer, depth, ")");
        }
    }
    
    
    protected function printCommandsAndArgsOn_depth_Simple(buffer : Array, depth:int) : void {
        pushOn_depth_string(buffer, depth, my_commandSpec+"\n");
        for each (var arg : * in args) {
            if (arg == null) {
                logInfo("Missing args in: "+my_commandSpec);
            } else {
                arg.printCodeOn_depth(buffer, depth+1);
            }
        }
    }

    public override function printCodeOn_depth(buffer : Array, depth:int) : void {
        printCommandsAndArgsOn_depth(buffer,depth);
        
        if (nextBlock != null) {
            nextBlock.printCodeOn_depth(buffer, depth);
        }
    } 
    
}

}