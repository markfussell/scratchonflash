package com.chimu.scratchplayer.objects {
    import com.chimu.scratchplayer.app.ScratchApp;
    import com.chimu.scratchplayer.blocks.CBlock;
    import com.chimu.scratchplayer.blocks.CommandBlock;
    import com.chimu.scratchplayer.blocks.EventHatBlock;
    import com.chimu.scratchplayer.blocks.HatBlock;
    import com.chimu.scratchplayer.blocks.IfElseBlock;
    import com.chimu.scratchplayer.blocks.ScratchBlock;
    import com.chimu.scratchplayer.blocks.SetterBlock;
    import com.chimu.scratchplayer.blocks.VariableBlock;
    import com.chimu.scratchplayer.translation.ScratchTranslatorLib;
    
    import flash.utils.Dictionary;
    
    
/**
 * The ScratchObject package contains
 * the core programming objects (the things which have
 * Behavior, State, and Identity ) for Scratch.
 * 
 * This 'Pack' also has functionality and dictionaries
 * that are used by all the Objects and the Blocks.
 * Originally this was on the class-side of ScriptableScratchMorph.
 * 
 * There are a few design changes within these 'object' classes,
 * and a few naming standard changes, but the core organiziation
 * is very similar to the Smalltalk code... for better (especially
 * in documentation and comparability) or worse.
 */
public class ScratchObjectPack {

    static protected const CONST_readVariable : String = "readVariable";
    static protected const CONST_changeVariable : String = "changeVariable";
    static protected const CONST_selector_setVar_to : String = "setVar:to:";
    static protected const CONST_selector_changeVar_by : String = "changeVar:by:";

    static protected const CONST_spec_setVar_to : String = "set %v to %n";
    static protected const CONST_spec_changeVar_by : String = "change %v by %n";

    //============================================================
    //============================================================
    //============================================================

    static protected var shared_BlockSpecDict : Dictionary;
    
    static protected var shared_tupleKeys_listVariables : Dictionary;
    static protected var shared_tupleKeys_variables : Dictionary;
    static protected var shared_tupleKeys_hats : Dictionary;
    static protected var shared_tupleKeys_comments : Dictionary;

    static public var shared_outerApp : ScratchApp;
    
    static protected function logInfo(info : String) : void {
        shared_outerApp.logInfo(info);
    }
    
    //============================================================
    //============================================================
    //============================================================
    
    static public function getWorld() : * {
        return null;
    }
    
    static public function initializeFor(app : ScratchApp) : void {
        shared_outerApp = app;
        
        shared_BlockSpecDict = new Dictionary();
        
        addSpecs(ScriptableScratchObject.blockSpecs());
        addSpecs(ScriptableScratchMorph.blockSpecs());
        addSpecs(SpriteMorph.blockSpecs());
        addSpecs(StageMorph.blockSpecs());

        shared_tupleKeys_variables = new Dictionary();
        shared_tupleKeys_variables["readVariable"] = 1;
        shared_tupleKeys_variables["changeVariable"] = 1;


        shared_tupleKeys_listVariables = new Dictionary();
        shared_tupleKeys_listVariables["deleteLine:ofList:"] = 1;
        shared_tupleKeys_listVariables["append:toList:"] = 1;
        shared_tupleKeys_listVariables["lineCountOfList:"] = 1;
        shared_tupleKeys_listVariables["getLine:ofList:"] = 1;


        shared_tupleKeys_hats = new Dictionary();
        shared_tupleKeys_hats["EventHatMorph"] = {objClass: EventHatBlock, objType: EventHatBlock.CONST_GenericEvent}
        shared_tupleKeys_hats["KeyEventHatMorph"] = {objClass: EventHatBlock, objType: EventHatBlock.CONST_KeyPressedEvent};
        shared_tupleKeys_hats["MouseClickEventHatMorph"] = {objClass: EventHatBlock, objType: EventHatBlock.CONST_MouseClickEvent};
        shared_tupleKeys_hats["WhenHatBlockMorph"] = {objClass: EventHatBlock, objType: EventHatBlock.CONST_GenericEvent}

        shared_tupleKeys_comments = new Dictionary();
        shared_tupleKeys_comments["comment:"] = 1;
        shared_tupleKeys_comments["scratchComment"] = 1;
    }
    
    static protected function addSpecs(list : Array) : void {
        for each (var spec : * in list) {
            var selector : String = spec.selector;
            shared_BlockSpecDict[selector] = spec;
        }
    }

    static public function findEvaluateFor(selector : String) : Function {
        var spec : * = shared_BlockSpecDict[selector];
        if (spec == null) {
            shared_outerApp.logInfo("Could not find a spec for selector: "+selector);
            return null;
        }
        return spec.eval;
    }

    //=========================================================
    //=========================================================
    //=========================================================
    
    static public function createStackFromTupleList_receiver(tupleList : Array, receiver : ScriptableScratchObject) : ScratchBlock {
        var stackTop : ScratchBlock = null;
        var previousBlock : ScratchBlock = null;
        
        for each (var tuple : * in tupleList) {
            var block : ScratchBlock = createBlockFromTuple_receiver(tuple, receiver);
            if (block != null) {
                if (previousBlock == null) {
                    stackTop = block;        
                } else {
                    previousBlock.nextBlock = block;
                } 
                previousBlock = block;
            }
        }

        return stackTop;
    }


    /**
     * This is partially following the original 'branching' within
     * the Smalltalk code, but ListVariables are actually just
     * another 'CustomBlock' type, so eventually I may collapse
     * the 'Var' blocks as well.
     * 
     * Actually all of these could easily be delegated into 
     * 'createBlockFromSpec', since that is a standard factory
     * method already.  Even better would be the Spec includes
     * the correct factory Class, but I did not do that yet.
     */
    static public function createBlockFromTuple_receiver(tuple : Array, scriptOwner : *) : ScratchBlock {
        var k : String = tuple[0];
        var result : ScratchBlock = null;
        
        if (isVariable(k)) {
            result = createVariableBlockFromTuple_receiver(tuple, scriptOwner);
        } else if (isListVariable(k)) {
            result = createListVariableBlockFromTuple_receiver(tuple, scriptOwner);
        } else if (isHat(k)) {
            result = createHatBlockFromTuple_receiver(tuple, scriptOwner); 
        } else if (isComment(k)) {
            result = createCommentBlockFromTuple_receiver(tuple,scriptOwner);
        } else {
            result = createCustomBlockFromTuple_receiver(tuple,scriptOwner);
        }
        
        if (result != null) {
            result.setupOwner(scriptOwner);
        }
        
        return result;
    }
    
    static protected function isVariable(k : String) : Boolean {
        return shared_tupleKeys_variables[k] != null;
    }

    static protected function isListVariable(k : String) : Boolean {
        return shared_tupleKeys_listVariables[k] != null;
    }

    static protected function isHat(k : String) : Boolean {
        return shared_tupleKeys_hats[k] != null;
    }
    
    static protected function isComment(k : String) : Boolean {
        return shared_tupleKeys_comments[k] != null;
    }
    
    
    //===================================================
    //===================================================
    //===================================================
    
    static protected function createCommentBlockFromTuple_receiver(tuple : Array, scriptOwner : ScriptableScratchMorph) : ScratchBlock {
        return null;
    }

    static protected function createVariableBlockFromTuple_receiver(tuple : Array, scriptOwner : ScriptableScratchMorph) : ScratchBlock {
        var varName : String = tuple[1];
        var rcvr : ScriptableScratchMorph = scriptOwner;
        
        //MLF: This was the approach in the original code,
        //but that became unweildy and buggy... so now ScratchObjects
        //know how to get to their stage (or conceptually any container)
        //when asked for a variable they have visibility to.
        /*
        if (!scriptOwner.hasVariable(varName)) {
            var stage : ScratchStageMorph = scriptOwner.getStage();
            if (stage != null) {
                stage.addVariable(varName);
                rcvr = stage;
            } else {
                scriptOwner.addVariable(varName);
            }   
        }
        */
        
        var k : String = tuple[0];
        if (k == CONST_readVariable) {
            return new VariableBlock().initReceiver_spec(rcvr, varName);
        }
        
        if (k == CONST_changeVariable) {
            var selector : String = tuple[2];
            if (selector == "set:to:") {selector = CONST_selector_setVar_to};
            if (selector == "changeUserVar:by:") {selector = CONST_selector_changeVar_by};
            var cmdSpec : String = null;
            if (selector == CONST_selector_setVar_to) {
                cmdSpec = CONST_spec_setVar_to;
            } else {
                cmdSpec = CONST_spec_changeVar_by;
            }
            cmdSpec = ScratchTranslatorLib.varSpecTranslationFor_varName(cmdSpec, varName);
            var block : SetterBlock = new SetterBlock().initReceiver_variable_selector_spec(rcvr, varName, selector, cmdSpec);
            
            var arg : * = tuple[3];
            if (arg is Array) {
                //If the argument is an Array, it is another Tuple that creates a Block
                var argBlock : * = createBlockFromTuple_receiver((arg as Array), scriptOwner);
                block.replaceArgBlock_by(block.getArgumentAt(0), argBlock);
            } else {
                //Otherwise, the value is just the value of the Argument
                block.getArgumentAt(0).setValue(arg);
            }
            
            return block;
        }
        
        return null;
    }


    static protected function createListVariableBlockFromTuple_receiver(tuple : Array, scriptOwner : ScriptableScratchMorph) : ScratchBlock {
        //MLF: See createVariable for the alternative paradigm... but now this
        //is just a call to 'createCustomBlock'
        
        return createCustomBlockFromTuple_receiver(tuple, scriptOwner);
    }


    static protected function createHatBlockFromTuple_receiver(tuple : Array, scriptOwner : ScriptableScratchMorph) : ScratchBlock {
        var hatDescriptor : * = findHatDescriptorForName(tuple[0]);
        var blockClass : Class = hatDescriptor.objClass;
        var eventType : String = hatDescriptor.objType;
        var block : HatBlock = new blockClass;
        
        var eventName : String = tuple[1];
        
        block.scriptOwner = scriptOwner;
        
        block.initEventType_name(eventType, eventName);
        
        //TODO: 
        // More stuff.
        
        return block;
    }

    static protected function findHatDescriptorForName(k : String) : * {
        return shared_tupleKeys_hats[k];
    } 

    static protected function createCustomBlockFromTuple_receiver(tuple : Array, scriptOwner : ScriptableScratchMorph) : ScratchBlock {
        var k : String = tuple[0];
        
        var selector : String = k; //?
        var spec : * = shared_BlockSpecDict[selector];
        if (spec == null) {
            shared_outerApp.logInfo("Had no Spec for: "+selector);
            return null;
        }
        
        var block : ScratchBlock = scriptOwner.createBlockFromSpec(spec);
        
        if (block is CommandBlock) {
            populateCommandBlock_tuple_receiver(block as CommandBlock, tuple, scriptOwner);
        }
        
        return block;
    }

    static protected function populateCommandBlock_tuple_receiver(block : CommandBlock, tuple : Array, scriptOwner : ScriptableScratchMorph) : void {
        var argCount : int = Math.min(block.args.length, tuple.length-1);
        for (var i:int = 0; i<argCount; i++) {
            var arg : * = tuple[i+1];
            
            if (arg is Array) {
                var argBlock : * = createBlockFromTuple_receiver(arg as Array, scriptOwner);
                block.replaceArgBlock_by(block.getArgumentAt(i),argBlock);
            } else {
                block.getArgumentAt(i).setValue(arg);
            } 
        }
        
        //=========================
        //=== Next section should move into the appropriate CommandBlock class (to avoid 'isKindOf:')
        //=========================
        
        if (block is CBlock) {
            if (tuple[tuple.length-1] is Array) {
                (block as CBlock).setFirstBlockList(createStackFromTupleList_receiver(tuple[tuple.length-1], scriptOwner));
            }    
        }
        
        if (block is IfElseBlock) {
            var arg1 : * = tuple[tuple.length-2];
            if (arg1 is Array) {
                (block as IfElseBlock).setTrueBlock(createStackFromTupleList_receiver(arg1, scriptOwner));
            }
            var arg2 : * = tuple[tuple.length-1];
            if (arg2 is Array) {
                (block as IfElseBlock).setFalseBlock(createStackFromTupleList_receiver(arg2, scriptOwner));
            }
        }
        
        
        //Reporter block
    }

}

}