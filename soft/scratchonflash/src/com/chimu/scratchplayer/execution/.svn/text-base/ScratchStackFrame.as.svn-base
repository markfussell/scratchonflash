package com.chimu.scratchplayer.execution {

/**
 * A ScratchStackFrame describes the state of a ScratchProcess 
 * 
 * Each ScratchProcess has a collection of StackFrames, each of which contains
 * the state of that level of the execution.
 */
public class ScratchStackFrame {
    public var parentFrame : ScratchStackFrame;
    public var expression : *;
    public var my_arguments : Array = new Array();
    public var pc : int = 0;
    public var startTime : int = 0;
    public var startValue : *;
    public var shouldUnlight : *;
    
    public function initExpression(anExpression : *) : ScratchStackFrame {
        expression = anExpression;
        return this;
    }
    
    public function initExpression_addArgument(anExpression : *, arg : *) : ScratchStackFrame {
        expression = anExpression;
        addArgument(arg);
        return this;
    }
    
    public function initShouldYield() : ScratchStackFrame {
        expression = CONST_shouldYield;
        return this;
    }
    
    public function getArguments() : Array {
        return my_arguments;
    }
    
    public function addArgument(arg : Object) : void {
        //trace("Push failed? "+my_arguments.push(arg));
        my_arguments.push(arg);
    }
    
    static protected const CONST_shouldYield : String = "shouldYield";
    
    public function shouldYield() : Boolean {
        return expression == CONST_shouldYield;
    }
}

}