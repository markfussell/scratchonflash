package com.chimu.scratchplayer.objects {
    import com.chimu.scratchplayer.blocks.CBlock;
    import com.chimu.scratchplayer.blocks.CommandBlock;
    import com.chimu.scratchplayer.blocks.EventHatBlock;
    import com.chimu.scratchplayer.blocks.IfElseBlock;
    import com.chimu.scratchplayer.blocks.ReporterBlock;
    import com.chimu.scratchplayer.blocks.ScratchBlock;
    import com.chimu.scratchplayer.execution.ScratchEvent;
    import com.chimu.scratchplayer.execution.ScratchProcess;
    
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    
/**
 * A ScriptableScratchObject is the core programming entity of Scratch.
 * 
 * Each ScriptableObject is an 'object' in the OO sense.  It has:
 *    * Identity (Different from all other objects)
 *    * Behavior (Built-in and user-defined)
 *    * State (Variables)
 * You talk to a ScriptableObject through events -- these are actually broadcasts
 * to all ScriptableObject.
 * 
 * In a ScratchPlayer, we only need to create and run ScriptableObject, so our interaction
 * is simpler than within the Scratch Editor. 
 */
public class ScriptableScratchObject {

    protected var my_objName : *;
    protected var my_vars : Dictionary;
    protected var my_listVars : Dictionary;
    protected var my_blocksBin : Array;
    
    protected var my_isClone : *;

    protected var my_stage : StageMorph;
    
    protected var my_submorphs : Array;


    //===========================================
    //=== Logging
    //===========================================
    
    static protected function logInfo(info : String) : void {
        ScratchObjectPack.shared_outerApp.logInfo(info);
    }
    
    //===========================================
    //=== Stage
    //===========================================
    
    public function getStage() : StageMorph {
        return my_stage;
    }

    public function setupStage(aStage : StageMorph) : void {
        my_stage = aStage;
    }

    public function findObjectNamed(name : String) : ScriptableScratchObject {
        if (my_submorphs == null) return null;
        
        for each (var submorph : * in my_submorphs) {
            if (submorph.my_objName == name) return submorph;    
        }
        
        return null;
    }
    
    //===========================================
    //=== Variable Control
    //===========================================
    

    public function hasVariable(varName : String) : Boolean {
        return my_vars[varName] != null;
    }

    public function addVariable(varName : String) : void {
        my_vars[varName] = 0;
    }
    
    public function getVariable(varName : String) : Object {
        if (my_vars.hasOwnProperty(varName)) {
            return my_vars[varName];
        }
        var stage : * = getStage();
        if ((stage != null) && (stage != this)) {
            return stage.getVariable(varName);
        } else {
            logInfo("Failed to find var: "+varName);
        } 
        return null;
    }
    
    public function setVar_to(varName : String, obj : *) : void {
        //logInfo("Set var: "+varName+" to: "+obj);
        if (my_vars.hasOwnProperty(varName)) {
            my_vars[varName] = obj;
            return;
        } 
        
        var stage : StageMorph = getStage();
        if ( (stage != null) && (stage != this) ) {
            stage.setVar_to(varName, obj);
        } else {
            logInfo("Failed to find var: "+varName);
        } 
    }
    
    public function hasListVariable(varName : String) : Boolean {
        //return my_listVars.hasOwnProperty(varName);
        return my_listVars[varName] != null;
    }

    public function addListVariable(varName : String) : void {
        //TODO: This may not make sense
        setListVariable_to(varName,new Array());
    }
    
    protected function setListVariable_to(varName : String, newValue : Array) : void {
        if (my_listVars.hasOwnProperty(varName)) {
            my_listVars[varName] = newValue;
            return;
        }
        var stage : * = getStage();
        if ((stage != null) && (stage != this)) {
            stage.setListVariable_to(varName, newValue);
        } else {
            logInfo("Failed to find list var: "+varName);
        }
    }
    
    
    public function getListVariable(varName : String) : Array {
        if (my_listVars.hasOwnProperty(varName)) {
            return my_listVars[varName];
        }
        var stage : * = getStage();
        if ((stage != null) && (stage != this)) {
            return stage.getListVariable(varName);
        } else {
            logInfo("Failed to find list var: "+varName);
        }
        return null;
    }
    
    public function getListVariable_Safe(varName : String) : Array {
        var list : Array = getListVariable(varName);
        if (list == null) {
            //addListVariable(varName);
            //list = getListVariable(varName);
        }
        
        return list;
    }
    
    public function getLine_ofList(line : * , varName : String) : Object {
        var list : Array = getListVariable_Safe(varName);
        if (line == 'last') {
            line = list.length - 1;
        } else if (line == 'first') {
            line = 0;
        }
        if (line < list.length) {
            return list[line];
        } else {
            return null;
        }
    }
    
    public function deleteLine_ofList(line : * , varName : String) : void {
        //logInfo("Delete Line: "+line+" from List: "+varName);
        var list : Array = getListVariable_Safe(varName);
        if (line == 'last') {
            line = list.length - 1;
        } else if (line == 'first') {
            line = 0;
        } else if (line == 'all') {
            if (list.length > 0) {
                setListVariable_to(varName, new Array());
            }
            return;
        }
        
        if (line < list.length) {
            setListVariable_to(varName, list.filter( function (entry : *, index: int, array : *) : Boolean { return index != line; } ));
        } else {
            return;
        }
    }
    
    public function append_toList(entry : *, varName : String) : void {
        //logInfo("Append to List: "+varName+" value: "+entry);
        var list : Array = getListVariable_Safe(varName);
        list.push(entry);
    }
    
    public function lineCountOfList(varName : String) : Object {
        var list : Array = getListVariable_Safe(varName);
        return list.length;
    }
    

    //===========================================
    //===========================================
    //===========================================
    
    public function findEvaluateFor(selector : String) : Function {
        return ScratchObjectPack.findEvaluateFor(selector);//shared_specToFunctionMap[selector];
    }


    //===================================================================================================
    //===================================================================================================
    //===================================================================================================
    
    static public function blockSpecs() : Array {
        var result : Array = new Array();
        
        //===============================================================
        
        result.push({label: "when %m clicked", type:"S", selector:"-", eval: null, defaultArgs: []});
        result.push({label: "when %k key pressed", type:"K", selector:"-", eval: null, defaultArgs: []});
        result.push({label: "when %m clicked", type:"M", selector:"-", eval: null, defaultArgs: []});
        result.push({label: "when I receive %e", type:"E", selector:"-", eval: null, defaultArgs: [] });

        result.push({label: "wait %n secs", type:"t", selector:"wait:elapsed:from:", eval: function(duration : *, elapsed: *, ignored : *) : void {this.wait_elapsed_from(duration,elapsed,ignored); }, defaultArgs: [1]});
        

        //============
        result.push({label: "forever", type:"c", selector:"doForever", eval: function() : void {this.doForever(); } });
        result.push({label: "repeat %n", type:"c", selector:"doRepeat", eval: function() : void {this.doRepeat(); }, defaultArgs: [10] });

        //============
        result.push({label: "broadcast %e", type:"-", selector:"broadcast:", eval: function(name:String) : void {this.broadcast(name); }});
        result.push({label: "broadcast %e and wait", type:"s", selector:"doBroadcastAndWait", eval: function() : void {this.doBroadcastAndWait(); } });

        //============
        result.push({label: "forever", type:"c", selector:"doForever", eval: function() : void {this.doForever(); } });
        result.push({label: "if %b", type:"c", selector:"doIf", eval: function() : void {this.doIf(); } });
        result.push({label: "if %b", type:"c", selector:"doIfElse", eval: function() : void {this.doIfElse(); }});
        result.push({label: "wait until %b", type:"s", selector:"doWaitUntil", eval: function() : void {this.doWaitUntil(); }});
        result.push({label: "repeat until %b", type:"c", selector:"doUntil", eval: function() : void {this.doUntil(); } });

        //============
        //result.push({label: "stop script", type:"s", selector:"doReturn", eval: exampleMorph2.doReturn});
        //result.push({label: "stop all", type:"-", selector:"stopAll", eval: exampleMorph2.stopAll});
        
        //===============================================================
        //=== Numbers
        
        result.push({label: "%n + %n", type:"r", selector:"+", eval: function(a:*, b:*) : * {return this.doPlus(a,b); },   defaultArgs: [0,0]});
        result.push({label: "%n - %n", type:"r", selector:"-", eval: function(a:*, b:*) : * {return this.doMinus(a,b); },   defaultArgs: [0,0]});
        result.push({label: "%n * %n", type:"r", selector:"*", eval: function(a:*, b:*) : * {return this.doTimes(a,b); },   defaultArgs: [0,0]});
        result.push({label: "%n / %n", type:"r", selector:"/", eval: function(a:*, b:*) : * {return this.doDivide(a,b); },   defaultArgs: [0,0]});
        
        //============

        result.push({label: "pick random %n to %n", type:"r", selector:"randomFrom:to:", eval: function(a:*, b:*) : Object {return this.randomFrom_to(a,b); } , defaultArgs: [1,10]});
        
        //============
        result.push({label: "%n < %n", type:"b", selector:"<", eval: function(a:*, b:*) : Boolean {return this.doLessThan(a,b); },   defaultArgs: [0,0]});
        result.push({label: "%n = %n", type:"b", selector:"=", eval: function(a:*, b:*) : Boolean {return this.doEqualTo(a,b); },    defaultArgs: [0,0]});
        result.push({label: "%n > %n", type:"b", selector:">", eval: function(a:*, b:*) : Boolean {return this.doGreaterThan(a,b); },    defaultArgs: [0,0]});

        //============
        result.push({label: "%b and %b", type:"b", selector:"&",   eval: function(a:*, b:*) : Boolean {return this.doAnd(a,b); }      , defaultArgs: [0,0]});
        result.push({label: "%b or %b",  type:"b", selector:"|",   eval: function(a:*, b:*) : Boolean {return this.doOr(a,b); }       , defaultArgs: [0,0]});
        result.push({label: "not %b",    type:"b", selector:"not", eval: function(a:*) : Boolean {return this.doNot(a); }        , defaultArgs: [0]});

        //============

        result.push({label: "%n mod %n", type:"r", selector:"doMod", eval: function(a:*, b:*) : Object {return this.doMod(a,b); },   defaultArgs: []});
        result.push({label: "round %n", type:"r", selector:"doRound", eval: function(a:*) : Object {return this.doRound(a); },   defaultArgs: []});

        //============

        //result.push({label: "%e of %e", type:"r", selector:"getAttribute:of:", eval: function(attr:*, obj:*) : void {this.getAttribute_of(attr,obj); },   defaultArgs: [0,0]});
        result.push({label: "%f of %n", type:"r", selector:"computeFunction:of:", eval: function(f:*, a:*) : Object {return this.computeFunction_of(f,a); },   defaultArgs: ["sqrt",10]});

        //===============================================================
        //=== Variables

        result.push({label: "set %v to %n", type:"-", selector:"setVar:to:", eval: function(a:*, b:*) : void {this.setVar_to(a,b); },   defaultArgs: [0,0]});

        //============
        result.push({label: "delete %n of %l", type:"-", selector:"deleteLine:ofList:", eval: function(line:*, varName:String) : void {(this as ScriptableScratchMorph).deleteLine_ofList(line, varName); },   defaultArgs: [0,0]});
        result.push({label: "item %n of %l", type:"-", selector:"getLine:ofList:", eval: function(line:*, varName:String) : Object {return (this as ScriptableScratchMorph).getLine_ofList(line, varName); },   defaultArgs: [0,0]});
        result.push({label: "add %n to %l", type:"-", selector:"append:toList:", eval: function(value:*, varName:String) : void {(this as ScriptableScratchMorph).append_toList(value, varName); },   defaultArgs: [0,0]});
        result.push({label: "length of %l", type:"-", selector:"lineCountOfList:", eval: function(varName:String) : Object {return (this as ScriptableScratchMorph).lineCountOfList(varName); },   defaultArgs: [0,0]});


        return result;
    }

    //=========================================================
    //=========================================================
    //=========================================================

    protected var my_selectorNotImplementedMap : Dictionary = new Dictionary(); 
    public function notYetImplemented(selector : String = null) : void {
        if (selector != null) {
            if (my_selectorNotImplementedMap.hasOwnProperty(selector)) {
                return;
            } else {
                my_selectorNotImplementedMap[selector]=selector;
            }
        }
        logInfo("Functionality "+(selector == null ? "" : "'"+selector+"'")+" is not-yet-implemented");
    }
    
    public function notYetImplementedValue(selector : String = null) : Object{
        if (selector != null) {
            if (my_selectorNotImplementedMap.hasOwnProperty(selector)) {
                return null;
            } else {
                my_selectorNotImplementedMap[selector]=selector;
            }
        }
        logInfo("Functionality "+(selector == null ? "" : "'"+selector+"'")+" is not-yet-implemented (value)");
        return null;
    }
    

    //=========================================================
    //=========================================================
    //=========================================================

    public function wait_elapsed_from(duration : *, elapsed: *, ignored : *) : void {
        return;
    }
    
    //=========================================================
    //=========================================================
    //=========================================================

    public function doMinus(a : *, b : *) : Object {
        return Number(a) - Number(b);
    }
    
    public function doPlus(a : *, b : *) : Object {
        return Number(a) + Number(b);
    }
    
    public function doDivide(a : *, b : *) : Object {
        return Number(a) / Number(b);
    }
    
    public function doTimes(a : *, b : *) : Object {
        return Number(a) * Number(b);
    }
    
    //=========================================================
    //=========================================================
    //=========================================================

    public function doGreaterThan(a : *, b : *) : Object {
        return Number(a) > Number(b);
    }
    
    public function doLessThan(a : *, b : *) : Object {
        return Number(a) < Number(b);
    }
    
    public function doEqualTo(a : *, b : *) : Object {
        var result : Boolean = (a == b);
        if (result) return result;
        
        result = (Number(a) == Number(b));
        if (result) return result;
        
        return result;
    }
    

    //=========================================================
    //=========================================================
    //=========================================================

    public function doAnd(a : *, b : *) : Boolean {
        return a && b;
    }
    
    public function doOr(a : *, b : *) : Boolean {
        return a || b;
    }
    
    public function doNot(a : *) : Boolean {
        return !a;
    }
    

    //=========================================================
    //=========================================================
    //=========================================================

    public function doMod(a : *, b : *) : Number {
        return a % b;
    }
    
    public function doRound(a : *) : Number {
        return Math.round(a);
    }
    
    //=========================================================
    //=========================================================
    //=========================================================

    public function randomFrom_to(a : *, b : *) : Number {
        return (Math.random() * (b - a)) + a;
    }
    
    static protected var CONST_functionNameToFunctionMap : Dictionary; 
    //abs,sqrt,sin,cos,tan,asin,acos,atan,ln,log,e ^, 10 ^
    
    
    public function computeFunction_of(f : *, a:*) : Number {
        switch(f) {
            case "abs": return Math.abs(a);
            case "sqrt": return Math.sqrt(a);
            case "sin": return Math.sin(a);
            case "cos": return Math.cos(a);
            case "tan": return Math.tan(a);
            case "asin": return Math.asin(a);
            case "acos": return Math.acos(a);
            case "atan": return Math.atan(a);
            case "ln": return Math.log(a);
            case "log": return Math.log(a) / Math.LN10;
            case "e ^": return Math.exp(a);
            case "10 ^": return (10 ^ a);
        }
        logInfo("Function: '"+f+"' is not implemented yet");
        return a;
    }
    
    
    

    //=========================================================
    //=== Other
    //=========================================================

    public function broadcast(name : String) : void {
           
    }
    
    public function broadcast_withArgument(name : String, arg : *) : void {
        getStage().broadcastCustomEventNamed_with(name, arg);
    }
    
    public function broadcastCustomEventNamed_with(name : String, arg : *) : Array {
        var event : ScratchEvent = new ScratchEvent().initType_name_argument(EventHatBlock.CONST_GenericEvent, name, arg);
        return broadcastEvent(event);
    }
        
    public function broadcastEventType_named_with(type : String, name : String, arg : *) : Array {
        var event : ScratchEvent = new ScratchEvent().initType_name_argument(type, name, arg);
        return broadcastEvent(event);
    }
        
    public function broadcastEvent(event : ScratchEvent) : Array {
        var newProcs : Array = new Array();

        for each (var submorph:ScriptableScratchMorph in my_submorphs) {
            newProcs = newProcs.concat(submorph.broadcastEvent(event));
        }

        broadcastEventToSelf_addTo(event, newProcs);
        return newProcs;
    }

    public function broadcastEventToSelf_addTo(event : ScratchEvent, newProcs : Array) : void {
        var eventScripts : Array = selectEventScriptsFor(event);

        for each (var hat:EventHatBlock in eventScripts) {
            var newProc : ScratchProcess = hat.startForEvent(event);
            if (newProc != null) {
                newProcs.push(newProc);
            }
        }
    }
    
    //=======================================================================
    //=======================================================================
    //=======================================================================
    
    
    public function getAttribute_of(attr : String, obj : ScriptableScratchMorph) : * {
        return obj.getAttribute(attr);
    } 
    
    public function getAttribute(attr : String) : * {
        //Map the attr-name to ivars and the like
        return null;
    }
    
    
    //=======================================================================
    //=======================================================================
    //=======================================================================
    
    
    protected var initFieldCount : int = 0;
    
    public function initFieldsFrom_version(fieldList : Array, classVersion : Number) : void {
        /**
        * bounds, owners, submorphs, color, flags
        * objName, vars, blocksBin, isClone, media, costume
        * ======
        * visibility, scalePoint, rotationDegrees, rotationStyle, volume, tempoBPM, draggable
        * ======
        * zoom, hPan, vPan, obsolete, sprites, volume, tempBPM,
        * ======
        * ???, listVars
        */
        
        initFieldCount = 0;
        initFieldsFrom_version_UseCounter(fieldList, classVersion);
        initFields2From_version_UseCounter(fieldList, classVersion);
        doneInitializeFields();
    }

    protected function initFieldsFrom_version_UseCounter(fieldList : Array, classVersion : Number) : void {
        //Completely delegated to my 'Morph' subclass because we are intertwined.
    }
    
    protected function doneInitializeFields() : void {
        
        //Expand the blocks
        var init_blocksBin : Array = my_blocksBin;
        
        var newBlocksBin : Array = new Array(); 
        for each (var eachStackPair : * in init_blocksBin) {
            var location : Point = eachStackPair[0];
            var eachStackTuples : Array = eachStackPair[1];
            
            var stack : * = ScratchObjectPack.createStackFromTupleList_receiver(eachStackTuples,this);
            
            //Can also filter this before pushing
            if (stack != null) {
                newBlocksBin.push(stack);
            }
        }
        my_blocksBin = newBlocksBin;
    }

    protected function initFields2From_version_UseCounter(fieldList : Array, classVersion : Number) : void {
        var i : int = initFieldCount;
        var init_unknownDict : * = fieldList[i++];
        var init_listVars : * = fieldList[i++];
        
        my_listVars = init_listVars;
        for (var key : * in my_listVars) {
            if (my_listVars[key] == null) {
                my_listVars[key] = new Array();
            }
        }
        
        initFieldCount = i;
    }

    

    //=======================================================================
    //=======================================================================
    //=======================================================================
    
    
    protected function selectEventScriptsFor(event : ScratchEvent) : Array {
        var result : Array = my_blocksBin.filter(function (block : ScratchBlock, index: int, array:Array) : Boolean {
            return block.respondsToEvent(event); 
        });
        return result;
    }
    
     
    //=======================================================================
    //=======================================================================
    //=======================================================================
    
    static protected const CONST_Selector_doIfElse : String = "doIfElse";
    
    static protected const CONST_HatTypes      : String = "EKMSW";
    static protected const CONST_CBlockTypes   : String = "c";
    static protected const CONST_ReporterTypes : String = "rb";

    
    protected function isHatBlock(blockType : String) : Boolean {
        return CONST_HatTypes.indexOf(blockType) >= 0;
    }

    protected function isCBlock(blockType : String) : Boolean {
        return CONST_CBlockTypes.indexOf(blockType) >= 0;
    }

    protected function isReporterBlock(blockType : String) : Boolean {
        return CONST_ReporterTypes.indexOf(blockType) >= 0;
    }


    public function createBlockFromSpec(spec : Object) : ScratchBlock {
        var blockLabelSpec : String = spec.label;
        var blockType : String = spec.type;
        var blockSelector : String = spec.selector;
        
        //MLF: Currently this is already weeded out before here
        /*
        if (isHatBlock(blockType)) {
            return createHatBlockType(blockType);
        };
        */
        
        //======================================
        //Create a CommandBlock of various kinds
        //======================================
        
        var block : CommandBlock;
        if (isCBlock(blockType)) {
            if (blockSelector == CONST_Selector_doIfElse) {
                block = new IfElseBlock();
            } else {
                block = new CBlock();
            }
        } else {
            if (isReporterBlock(blockType)) {
                block = new ReporterBlock();
            } else {
                block = new CommandBlock();
            }
        }
        
        //Boolean/Special/Timed... ?
        block.setBlockType(blockType);
        
        var rcvr : * = this;
        /*
        if (!isSpriteSpecificTarget_selector(this,blockSelector)) {
            rcvr = getStage();
        }
        */
        
        block.selector = blockSelector;
        block.receiver = rcvr;
        block.setupCommandSpec(blockLabelSpec);
        
        return block
    }
    

    protected function printSpriteDeclarOn_depth(buffer : Array, depth:int) : void {
        buffer.push("sprite: "+my_objName+"\n");
    }
    
    protected function printVarsHeaderOn_depth(buffer : Array, depth:int) : void {
            buffer.push("\n");
            buffer.push("#============\n");
            buffer.push("#=== Vars \n");
            buffer.push("#============\n");
    }
    
    public function printCodeOn_depth(buffer : Array, depth:int) : void {
        buffer.push("\n");
        buffer.push("#===========================\n");
        buffer.push("#=== Morph: "+my_objName+" \n");
        buffer.push("#===========================\n");
        printSpriteDeclarOn_depth(buffer,depth);


        var outputVars : Boolean = false;
        var outputListVars : Boolean = false;
        var outputVarsHeader : Boolean = false;
        
        for (var aVar : String in my_vars) {
            if (!outputVarsHeader) {
                printVarsHeaderOn_depth(buffer,depth);
                outputVarsHeader = true;        
            }
            if (!outputVars) {
                buffer.push("\n");
                buffer.push("vars:\n");
                outputVars = true;
            }
            buffer.push(""+aVar+" = "+my_vars[aVar]+"\n");
        }
        for (var aListVar : String in my_listVars) {
            if (!outputVarsHeader) {
                printVarsHeaderOn_depth(buffer,depth);
                outputVarsHeader = true;        
            }
            if (!outputListVars) {
                buffer.push("\n");
                buffer.push("listVars:\n");
                outputListVars = true;
            }
            buffer.push(""+aListVar+" = "+my_listVars[aVar]+"\n");
        }
        
        for each (var block : ScratchBlock in my_blocksBin) {
            buffer.push("\n");
            buffer.push("#============\n");
            buffer.push("#=== Script \n");
            buffer.push("#============\n");
            buffer.push("script:\n");
            buffer.push("\n");
            block.printCodeOn_depth(buffer, depth);
        }
        
        for each (var submorph : ScriptableScratchMorph in my_submorphs) {
            buffer.push("\n");
            submorph.printCodeOn_depth(buffer, depth);
        }
    } 
    
    
/**/
    
}


}