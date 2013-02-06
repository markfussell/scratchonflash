package com.chimu.scratchplayer.execution {
    import com.chimu.scratchplayer.blocks.CommandBlock;
    import com.chimu.scratchplayer.blocks.IfElseBlock;
    import com.chimu.scratchplayer.blocks.ScratchBlock;
    import com.chimu.scratchplayer.objects.ScratchObjectPack;
    import com.chimu.scratchplayer.objects.StageMorph;
    
    import mx.controls.Alert;
    

/**
 * A ScratchProcess is what brings a stack of blocks to life.
 * The process keeps track of which block to run next, evaluates block arguments,
 * handles control structures, and so forth.
 * 
 * The ScratchScheduler is the scheduler (owner) for processes.
 */
public class ScratchProcess {
    protected var my_stackFrame : ScratchStackFrame;
    protected var my_readyToYield : Boolean = false;
    protected var my_readyToTerminate : Boolean = false;
    protected var my_errorFlag : Boolean = false;


    public function initExpression(expression : * ) : ScratchProcess {
        if (my_stackFrame != null) {
            Alert.show("Cannot modify expression");
            return this;
        }
        my_stackFrame = new ScratchStackFrame().initExpression(expression);
        
        return this;
    }
    
    public function runStepFor(scheduler : ScratchScheduler) : void {
        my_readyToYield = false;
        while( (my_stackFrame != null) && !my_readyToYield ) {
            evaluateFor(scheduler);
        }
        
        if (my_readyToTerminate) {
            while (my_stackFrame != null) {
                popStackFrame();
            }  
        }
       
    }
    
    protected function yield() : void {
        my_readyToYield = true;
        popStackFrame();
    }
    
    protected function evaluateFor(scheduler : ScratchScheduler) : void {
        if (my_stackFrame.shouldYield()) {
            yield();
            return;
        }
        
        //=============================
        
        var expression_obj : * = my_stackFrame.expression;
        
        if (expression_obj is Array) {
            evaluateSequence();
            return;
        }

        //=============================
        
        var expression : ScratchBlock = (expression_obj as ScratchBlock); 
        
        if (expression.isComment()) {
            popStackFrame();
            return;
        }
        
        if (expression.isSelfEvaluating()) {
            evaluateSelfEvaluating();
            return;
        }
        
        if (expression.isCommand()) {
            evaluateCommandFor(scheduler);
            return;
        }
        
        trace("Unrecognized expression: "+expression);
        popStackFrame();
    }
    
    protected function evaluateSequence() : void {
        var blocks : Array = (my_stackFrame.expression as Array);
        var pc : Number = (my_stackFrame.pc);
        
        if (pc < blocks.length) {
            my_stackFrame.pc += 1;
            pushStackFrame(new ScratchStackFrame().initExpression(blocks[pc]));
        } else {
            popStackFrame();
        }
    }
    
    protected function evaluateCommandFor(scheduler : ScratchScheduler) : void {
        var expression : ScratchBlock = (my_stackFrame.expression as ScratchBlock);
        
        if (expression.isSpecialForm()) {
            expression.evaluateSpecialFormOn(this);
            return;
        }
        
        if (my_stackFrame.getArguments().length < expression.getArgumentCount()) {
            evaluateNextArgument();
            return;   
        }
        
        if (expression.isTimed()) {
            applyTimedCommand();
            return;
        }
        
        applyPrimitive();
        
        if (scheduler != null) {
            scheduler.getStage().updateTrailsForm();
            //blockHighlightBehavior (redraw)
            //This would actually have to be some kind of serious 'yield' in the outer loop vs. here
        }
        
    }
    
    protected function evaluateNextArgument() : void {
        var argumentExpression : * = (my_stackFrame.expression as CommandBlock).getArgumentAt(my_stackFrame.getArguments().length);
        pushStackFrame(new ScratchStackFrame().initExpression(argumentExpression));
    }
    
    
    protected function applyTimedCommand() : void {
        var currentTime : Number = new Date().getTime();
        var startTime : Number = my_stackFrame.startTime;
        var block : CommandBlock = my_stackFrame.expression;
        var args : Array = my_stackFrame.getArguments().concat();
        
        //TimedCommandBlock...
        
        if ( startTime == 0 ) {
            //args... add on the timing arg itself
            args.push(currentTime,null);
            
            my_stackFrame.startValue = block.evaluateWithArgs(args);
            my_stackFrame.startTime = currentTime;
            my_readyToYield = true;
            return;
        }
        
        
        args.push(currentTime - my_stackFrame.startTime, my_stackFrame.startValue);
        var newValue : * = block.evaluateWithArgs(args);
        
        //Use a null value as a flag of being done.
        if (newValue == null) {
            popStackFrame();
        } else {
            my_readyToYield = true;
        }
    }

    protected function applyPrimitive() : void {
        var value : * = (my_stackFrame.expression as CommandBlock).evaluateWithArgs(my_stackFrame.getArguments());
        returnValueToParentFrame(value);
        popStackFrame();
    }
    
    protected function evaluateSelfEvaluating() : void {
        var value : * = (my_stackFrame.expression as ScratchBlock).evaluate();
        returnValueToParentFrame(value);
        popStackFrame();
    }
    
    
    protected function returnValueToParentFrame(anObject : *) : void {
        if (my_stackFrame == null) {return;};
        
        var parentFrame : ScratchStackFrame = my_stackFrame.parentFrame;
        if (parentFrame != null) {
            parentFrame.addArgument(anObject);
        } 
                
    }
    
    protected function popStackFrame() : void {
        //MLF: Don't actually need to do the rest
        //var frame : ScratchStackFrame = my_stackFrame;
        my_stackFrame = my_stackFrame.parentFrame;
        
        //var command : * = frame.getExpression();
    }
    
    protected function pushStackFrame(aFrame : ScratchStackFrame) : void {
        aFrame.parentFrame = my_stackFrame;
        my_stackFrame = aFrame;
    }
    
    public function isRunning() : Boolean {
        return (my_stackFrame != null) && !my_errorFlag;
    }


    public function stop() : void {
        
    }


    //============================================================
    //============================================================
    //============================================================

    public function findEvaluateSpecialFor(selector : String) : Function {
        return ScratchObjectPack.findEvaluateFor(selector);//shared_specToFunctionMap[selector];
    }

    protected function popAndYieldPush(block : *) : void {
        popStackFrame();
        pushStackFrame(new ScratchStackFrame().initExpression(block));
        pushStackFrame(new ScratchStackFrame().initShouldYield());
    }

    protected function popAndYieldPush_addArgument(block : *, arg: * ) : void {
        popStackFrame();
        pushStackFrame(new ScratchStackFrame().initExpression_addArgument(block, arg));
        pushStackFrame(new ScratchStackFrame().initShouldYield());
    }

    //============================================================
    //===  Special Forms
    //============================================================

    public function doBroadcastAndWait() : void {
        var block : CommandBlock = my_stackFrame.expression;
        var args : Array = my_stackFrame.getArguments();
        
        var procs : Array = null;
        if (args.length == 0) {
            var eventName : * = block.args[0].evaluate(); //MLF: Driving into the ArgBlock (static events)
            var stage : StageMorph = block.getStage();
            procs = stage.broadcastCustomEventNamed_with(eventName, 0);
        } else {
            procs = args[0];
        }
        
        var runningProcs : Array = procs.filter(function (eachProc : ScratchProcess, index : int, array : Array) : Boolean {return eachProc.isRunning()} );
        if (runningProcs.length == 0) {
            popStackFrame();
            return;
        }

        popAndYieldPush_addArgument(block,procs);
    }
    

    public function doForever() : void {
        var block : ScratchBlock = my_stackFrame.expression;

        //Although a 'Forever' does not modify the current frame, we use 
        //the same pattern as for the others

        popAndYieldPush(block);

        pushStackFrame(new ScratchStackFrame().initExpression(block.firstBlockList()));
    }
    
    
    public function doForeverIf() : void {
        var block : ScratchBlock = my_stackFrame.expression;
        var args : Array = my_stackFrame.getArguments();

        if (args.length == 0) {
            evaluateNextArgument();
            return;
        }
        
        popAndYieldPush(block);
        
        if (args[0]) {
            pushStackFrame(new ScratchStackFrame().initExpression(block.firstBlockList()));
        } else {
            //Nada
        }
    }

    
    //=============================================
    //=============================================
    //=============================================

    public function doIf() : void {
        var block : ScratchBlock = my_stackFrame.expression;
        var args : Array = my_stackFrame.getArguments();

        if (args.length == 0) {
            evaluateNextArgument();
            return;
        }
        
        popStackFrame();
        
        if (args[0]) {
            pushStackFrame(new ScratchStackFrame().initExpression(block.firstBlockList()));
        } else {
            //Nada
        }
    }
    
    //=============================================
    //=============================================
    //=============================================

    public function doIfElse() : void {
        var block : IfElseBlock = my_stackFrame.expression;
        var args : Array = my_stackFrame.getArguments();

        if (args.length == 0) {
            evaluateNextArgument();
            return;
        }
        
        popStackFrame();
        
        if (args[0]) {
            pushStackFrame(new ScratchStackFrame().initExpression(block.trueBlockList()));
        } else {
            pushStackFrame(new ScratchStackFrame().initExpression(block.falseBlockList()));
        }
    }
    
    //=============================================
    //=============================================
    //=============================================

    public function doPlaySoundAndWait() : void {
        //TODO: 
    }
    
    //=============================================
    //=============================================
    //=============================================

    public function doRepeat() : void {
        var block : CommandBlock = my_stackFrame.expression;
        var args : Array = my_stackFrame.getArguments();

        if (args.length == 0) {
            evaluateNextArgument();
            return;
        }
        
        var counter : * = args[0];
        if (counter <=0) {
            popStackFrame();
            return;
        }
        
        
        popAndYieldPush_addArgument(block,counter-1);

        pushStackFrame(new ScratchStackFrame().initExpression(block.firstBlockList()));
    }
    
    //=============================================
    //=============================================
    //=============================================

    public function doReturn() : void {
        var block : CommandBlock = my_stackFrame.expression;
        var args : Array = my_stackFrame.getArguments();

        if (args.length < block.getArgumentCount()) {
            evaluateNextArgument();
            return;
        }

        var value : * = null;
        if (args.length > 0) {
            value = args[0];
        } 
        
        while (my_stackFrame != null) {
            popStackFrame();
        } 
        
        //TODO:
        //MLF: I don't see how this could ever be true... 
        if (my_stackFrame != null) {
            returnValueToParentFrame(value);
            popStackFrame();
        }
    }
    
    //=============================================
    //=============================================
    //=============================================

    public function doUntil() : void {
        doUntil_TerminatingOn(true);
    }
    
    //=============================================
    //=============================================
    //=============================================

    public function doWaitUntil() : void {
        var block : CommandBlock = my_stackFrame.expression;
        var args : Array = my_stackFrame.getArguments();

        if (args.length == 0) {
            evaluateNextArgument();
            return;
        }
        

        if (args[0]) {
            popStackFrame();
            return;
        }

        popAndYieldPush(block);
    }
    
    
    //=============================================
    //=============================================
    //=============================================
    
    public function doWhile() : void {
        doUntil_TerminatingOn(false);
    }
    
    
    //=============================================
    //=============================================
    //=============================================
    
    
    public function doUntil_TerminatingOn(terminatingFlag : Boolean) : void {
        var block : ScratchBlock = my_stackFrame.expression;
        var args : Array = my_stackFrame.getArguments();
        
        //Not sure why this has to be hard-coded.  I think expression should know the answer
        if (args.length < 1) {
            evaluateNextArgument();
            return;
        }
        
        if (args[0] == terminatingFlag) {
            popStackFrame();
            return;
        }
        
        popAndYieldPush(block);

        pushStackFrame(new ScratchStackFrame().initExpression(block.firstBlockList()));
    }
    

}

}