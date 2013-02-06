package com.chimu.scratchplayer.objects {
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    

/**
 * A SpriteMorph is a moveable ScratchMorph that 
 * plays on the Stage.
 * 
 * Was: ScratchSpriteMorph (I just dropped the 'Scratch' prefix)
 */
public class SpriteMorph extends ScriptableScratchMorph {
    protected var my_scalePoint : Point;
    
    
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================

    static public function blockSpecs() : Array {
        var result : Array = new Array();
        
        //===============================================================
        //=== Motion
        
        result.push({label: "move %n steps", type:"-", selector:"forward:", eval: function(distance : *) : void {this.forward(distance); } , defaultArgs: []});
        result.push({label: "turn %n degrees", type:"-", selector:"turnRight:", eval: function(degrees : *) : void {this.turnRight(degrees); } , defaultArgs: [15]});
        result.push({label: "turn %n degrees", type:"-", selector:"turnLeft:", eval: function(degrees : *) : void {this.turnLeft(degrees); } , defaultArgs: [15]});
        
        //============
        result.push({label: "point in direction %d", type:"-", selector:"heading:", eval: function(degrees : *) : void {this.heading(degrees); } , defaultArgs: [90]});
        result.push({label: "point towards %m", type:"-", selector:"pointTowards:", eval: function(a:*) : void {this.pointTowards(a); } , defaultArgs: []});

        //============
        result.push({label: "go to x:%n y:%n", type:"-", selector:"gotoX:y:", eval: function(x:*, y:*) : void {this.gotoX_y(x,y); } , defaultArgs: [0,0]});
        result.push({label: "go to %m", type:"-", selector:"gotoSpriteOrMouse:", eval: function(a:*) : void {this.gotoSpriteOrMouse(a); } , defaultArgs: []});
        result.push({label: "glide %n secs to x:%n y:%n", type:"t", selector:"glideSecs:toX:y:elapsed:from:", eval: function(secs:*,x:*,y:*,elapsed:*,startPoint:*) : Object { return this.glideSecs_toX_y_elapsed_from(secs,x,y,elapsed,startPoint); } , defaultArgs: [1,50,50]});

        //============
        result.push({label: "change x by %n", type:"-", selector:"changeXposBy:", eval: function(a:*) : void {this.changeXposBy(a); } , defaultArgs: [10]});
        result.push({label: "set x to %n", type:"-", selector:"xpos:", eval: function(x:*) : void {this.setXpos(x); } , defaultArgs: [0]});
        result.push({label: "change y by %n", type:"-", selector:"changeYposBy:", eval: function(a:*) : void {this.changeYposBy(a); } , defaultArgs: [10]});
        result.push({label: "set y to %n", type:"-", selector:"ypos:", eval: function(y:*) : void {this.setYpos(y); } , defaultArgs: [0]});

        //============
        result.push({label: "if on edge, bounce", type:"-", selector:"bounceOffEdge", eval: function() : void {this.bounceOffEdge(); } , defaultArgs: []});

        //============
        result.push({label: "xpos", type:"r", selector:"xpos", eval: function() : Object {return this.getXpos(); } , defaultArgs: []});
        result.push({label: "ypos", type:"r", selector:"ypos", eval: function() : Object {return this.getYpos(); } , defaultArgs: []});
        result.push({label: "direction", type:"r", selector:"heading", eval: function() : Object {return this.getHeading(); } , defaultArgs: []});


        //===============================================================
        //=== Pen
        
        result.push({label: "pen down", type:"-", selector:"putPenDown", eval: function() : void {this.putPenDown(); } , defaultArgs: []});
        result.push({label: "pen up", type:"-", selector:"putPenUp", eval: function() : void {this.putPenUp(); } , defaultArgs: []});
        
        //============
        result.push({label: "set pen color to %c", type:"-", selector:"penColor:", eval: function(color : *) : void {this.setPenColor(color); } , defaultArgs: []});
        result.push({label: "change pen color by %n", type:"-", selector:"changePenHueBy:", eval: function() : void {this.notYetImplemented(); } , defaultArgs: []});
        result.push({label: "set pen color to %n", type:"-", selector:"setPenHueTo:", eval: function() : void {this.notYetImplemented(); } , defaultArgs: [0]});
        
        //============
        result.push({label: "change pen shade by %n", type:"-", selector:"changePenShadeBy:", eval: function() : void {this.notYetImplemented(); } , defaultArgs: []});
        result.push({label: "set pen shade to %n", type:"-", selector:"setPenShadeTo:", eval: function() : void {this.notYetImplemented(); } , defaultArgs: [50]});
        
        //============
        result.push({label: "change pen size by %n", type:"-", selector:"changePenSizeBy:", eval: function(a:*) : void {this.changePenSizeBy(a); } , defaultArgs: [1]});
        result.push({label: "set pen size to %n", type:"-", selector:"penSize:", eval: function(size:*) : void {this.setPenSize(size); } , defaultArgs: [1]});
        
        //============
        result.push({label: "stamp", type:"-", selector:"stampCostume", eval: function() : void {this.stampCostume(); } , defaultArgs: []});
        
        //===============================================================
        //=== Looks
        
        result.push({label: "say %s for %n seconds",    type:"t", selector:"say:duration:elapsed:from:", eval: function(say:*,duration:*,elapsed:*,from:*) : void {this.say_duration_elapsed_from(say, duration, elapsed, from); } , defaultArgs: ["Hello!",2]});
        result.push({label: "say %s",    type:"-", selector:"say:", eval: function(say:*) : void {this.say(say); } , defaultArgs: ["Hello!"]});
        result.push({label: "think %s for %n seconds",    type:"t", selector:"think:duration:elapsed:from:", eval: function(say:*,duration:*,elapsed:*,from:*) : void {this.think_duration_elapsed_from(say, duration, elapsed, from); } , defaultArgs: ["Hmm...",2]});
        result.push({label: "think %s",    type:"-", selector:"think:", eval: function(say:*) : void {this.think(say); } , defaultArgs: ["Hmm...!"]});


        //============
        
        result.push({label: "change %g effect by %n", type:"-", selector:"changeGraphicEffect:by:", eval: function(effect:*, by:*) : void {this.changeGraphicEffect_by(effect, by); } , defaultArgs: ['color',25]});
        result.push({label: "set %g effect to %n%", type:"-", selector:"setGraphicEffect:to:", eval: function() : void {this.notYetImplemented("setGraphicEffect:to:"); } , defaultArgs: ['color',0]});
        result.push({label: "clear graphic effects", type:"-", selector:"filterReset", eval: function() : void {this.notYetImplemented("clear graphic effects"); } , defaultArgs: [100]});

        //============
        
        result.push({label: "change size by %n", type:"-", selector:"changeSizeBy:", eval: function(by : *) : void {this.changeSizeBy(by); } , defaultArgs: []});
        result.push({label: "set size to %n%", type:"-", selector:"setSizeTo:", eval: function(value : *) : void {this.setSizeTo(value); } , defaultArgs: [100]});
        result.push({label: "size", type:"r", selector:"scale", eval: function() : Object {return this.notYetImplementedValue(); } , defaultArgs: []});

        //============

        result.push({label: "show", type:"-", selector:"show", eval: function() : void {this.show(); } , defaultArgs: []});
        result.push({label: "hide", type:"-", selector:"hide", eval: function() : void {this.hide(); } , defaultArgs: []});

        //============

        result.push({label: "go to front", type:"-", selector:"comeToFront", eval: function() : void {this.notYetImplemented("comeToFront"); } , defaultArgs: []});
        result.push({label: "go back %n layers", type:"-", selector:"goBackByLayers:", eval: function() : void {this.notYetImplemented("goBackByLayers:"); } , defaultArgs: [1]});

        //===============================================================
        //=== Sensing


        result.push({label: "touching %m", type:"b", selector:"touching:", eval: function() : Object {return this.notYetImplementedValue("touching:"); } , defaultArgs: []});
        result.push({label: "touching color %m", type:"b", selector:"touchingColor:", eval: function() : Object {return this.notYetImplementedValue("touchingColor:"); } , defaultArgs: []});
        result.push({label: "color %C is touching %C", type:"b", selector:"color:sees:", eval: function() : Object {return this.notYetImplementedValue("color:sees:"); } , defaultArgs: []});

        //============

        result.push({label: "distance to %m", type:"r", selector:"distanceTo:", eval: function() : Object {return this.notYetImplementedValue("distanceTo:"); } , defaultArgs: []});

        //============

        result.push({label: "%H sensor value", type:"r", selector:"sensor:", eval: function() : Object {return this.notYetImplementedValue("sensor:"); } , defaultArgs: ["slider"]});
        result.push({label: "sensor %h", type:"b", selector:"sensorPressed:", eval: function() : Object {return this.notYetImplementedValue("sensorPressed:"); } , defaultArgs: ["button pressed"]});

        
        //===============================================================
        
        return result;
    }
    
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================


    public function forward(distance : Number) : void {
        my_sprite.forward(distance);
    }



    public function turnRight(degrees : Number) : void {
        my_sprite.turnRight(degrees);
    }
    

    public function turnLeft(degrees : Number) : void {
        my_sprite.turnLeft(degrees);
    }
    
    
    public function heading(degrees : Number) : void {
        my_sprite.heading(degrees);
    }
    
    static protected const CONST_mouseTarget : String = "mouse";
    public function pointTowards(target : *) : void {
        if (target == CONST_mouseTarget) {
            var mouse : Point = getStage().getLastMousePosition();
            my_sprite.headTowards_FXY(mouse);
            //notYetImplemented("Pointing at Mouse: "+mouse);
        } else if (target is SpriteMorph) {
            var targetSprite : SpriteMorph = (target as SpriteMorph);
            my_sprite.headTowards_FXY(targetSprite.my_sprite.getPosition_FXY());
        } else {
            var morph : * = getStage().findObjectNamed(target);
            if (morph == null) {
                notYetImplemented("Could not find: "+target);
            } else if (morph is SpriteMorph) {
                var sprite : SpriteMorph = (morph as SpriteMorph);
                my_sprite.headTowards_FXY(sprite.my_sprite.getPosition_FXY());
            } else {
                notYetImplemented("Target was not a Sprite: "+target);            
            }
        }
    }
    
    
    public function gotoSpriteOrMouse(target : *) : void {
        if (target == CONST_mouseTarget) {
            var mouse : Point = getStage().getLastMousePosition();
            my_sprite.moveTo_FXY(mouse);
            //notYetImplemented("Pointing at Mouse: "+mouse);
        } else if (target is SpriteMorph) {
            var targetSprite : SpriteMorph = (target as SpriteMorph);
            my_sprite.moveTo_FXY(targetSprite.my_sprite.getPosition_FXY());
        } else {
            notYetImplemented("Target was not recognized: "+target);            
        }
    }
    
    
    public function gotoX_y(x : Number, y: Number) : void {
        my_sprite.gotoX_y(x, y);
    }
    
    
    //=========================
    //=========================
    //=========================

    //These could actually be implemented either place since
    //they are just wrappers on the above behavior
    
    public function setXpos(x : Number) : void {
        my_sprite.setXpos(x);
    }
    
    public function setYpos(y : Number) : void {
        my_sprite.setYpos(y);
    }
    
    public function changeXposBy(a : Number) : void {
        my_sprite.changeXposBy(a);
    }
    
    public function changeYposBy(a : Number) : void {
        my_sprite.changeYposBy(a);
    }
    
    public function getXpos() : Object {
        return my_sprite.getPosition().x;
    }
    
    public function getYpos() : Object {
        return my_sprite.getPosition().y;
    }
    
    public function getHeading() : Object {
        return my_sprite.getHeading();
    }
    
    public function bounceOffEdge() : void {
        my_sprite.bounceOffEdge();
    }
    
    //=========================
    //=========================
    //=========================


    protected override function noteCostumeChanged() : void {
        super.noteCostumeChanged();
        
        my_sprite.setCostumeTo_rotationCenter(my_costume.form, my_costume.rotationCenter);
    } 
    
    //=========================
    //=========================
    //=========================


    public function say_duration_elapsed_from(say : String , duration : int , elapsed : int , from: *) : Object {
        if (from == null) {
            logInfo("Sprite said: '"+say+"' for "+duration+" seconds, but not implemented");
            return true;
        }
        
        if (elapsed < (duration*1000) ) {
            return true;
        } else {
            return null;
        }
    }

    public function say(say : String) : void {
        logInfo("Sprite said: "+say+" but not implemented");
    }

    public function think_duration_elapsed_from(say : String , duration : int , elapsed : int , from: *) : Object {
        if (from == null) {
            logInfo("Sprite thought: '"+say+"' for "+duration+" seconds, but not implemented");
            return true;
        }
        
        if (elapsed < (duration*1000) ) {
            return true;
        } else {
            return null;
        }
    }

    public function think(say : String) : void {
        logInfo("Sprite thought: "+say+" but not implemented");
    }



    //===================================================================================================
    //===================================================================================================
    //===================================================================================================
    //=== Looks

    public function changeSizeBy(by : Number) : void {
        my_sprite.changeSizeBy(by);
    }
        
    public function setSizeTo(value : Number) : void {
        my_sprite.setSizeTo(value);
    }

    public function changeGraphicEffect_by(effect : String, by : Number) : void {
        my_sprite.changeGraphicEffect_by(effect,by);
    }

    public function show() : void {
        my_sprite.show();
    }

    public function hide() : void {
        my_sprite.hide();
    }

    //===================================================================================================
    //===================================================================================================
    //===================================================================================================
    //=== Pens

    public function stampCostume() : void {
        getStage().stampCostumeForSprite(my_sprite);
    }
    
    public function putPenDown() : void {
        my_sprite.putPenDown();//my_isPenDown = true;
    }
    
    public function putPenUp() : void {
        my_sprite.putPenUp();//my_isPenDown = false;
    }
    
    public function setPenColor(color : *) : void {
        my_sprite.setPenColor(color);
    }
    
    public function setPenSize(size : *) : void {
        my_sprite.setPenSize(size);
    }
    
    public function changePenSizeBy(a : *) : void {
        my_sprite.changePenSizeBy(a);
    }
    
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================
    
    
    public function glideSecs_toX_y_elapsed_from(secs : Number ,x : Number, y : Number, elapsed : int  ,startPoint : Point) : Object {
        if (startPoint == null) {
            //logInfo("glideSecs_toX_y_elapsed_from: "+secs+","+x+","+y);
            return my_sprite.getPosition();
        }
        
        var millis : Number = secs * 1000;
        var ratio : Number = Math.min(elapsed / millis, 1);
        
        var newX : Number = Math.round(startPoint.x + (x - startPoint.x) * ratio); 
        var newY : Number = Math.round(startPoint.y + (y - startPoint.y) * ratio); 
        //var newPoint : Point = new Point(x,y);
        //if (true) return null;
        
        my_sprite.moveToX_y(newX, newY);
        
        if (elapsed < (secs*1000) ) {
            return new Point(newX, newY);
        } else {
            return null;
        }
    }    

    //===============================================================
    //=== Sensing
    //===============================================================


    public function doesColor_seeColor(sensitiveColor : *, soughtColor : *) : Boolean {
        //This requires a Bitmap-oriented process
        var stageImage : BitmapData = null; //getStage().getPatchAt_without_andNothingAbove(bounds, this, ???);
        var thisImage : BitmapData = new BitmapData(my_sprite.width, my_sprite.height);
        thisImage.draw(my_sprite);
        //Mask me with similar threshold
        
        var stageMask : BitmapData = new BitmapData(stageImage.width, stageImage.height);
        var pt : Point = new Point(0,0);
        var rect : Rectangle = new Rectangle(0,0,stageImage.width, stageImage.height);
        stageMask.threshold(stageImage, rect, pt,  "==", soughtColor);
        
        //Has to be fully opaque to be 'on'
        var alphaLevel : uint = 0xFF;

        return thisImage.hitTest(pt, alphaLevel, stageImage, pt, alphaLevel);
    }
    
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================
    
    protected override function initFieldsFrom_version_UseCounter(fieldList : Array, classVersion : Number) : void {
        super.initFieldsFrom_version_UseCounter(fieldList, classVersion);
        
        /**
        * bounds, owners, submorphs, color, flags, properties
        * objName, vars, blocksBin, isClone, media, costume
        * ======
        * visibility, scalePoint, rotationDegrees, rotationStyle, volume, tempoBPM, draggable
        * ======
        * zoom, hPan, vPan, obsolete, sprites, volume, tempBPM,
        */
        
        var i : int = initFieldCount;
        var init_visibility    : * = fieldList[i++];
        var init_scalePoint    : * = fieldList[i++];
        var init_rotationDegrees : * = fieldList[i++];
        var init_rotationStyle : * = fieldList[i++];
        var init_volume        : * = fieldList[i++];
        var init_tempBPM       : * = fieldList[i++];
        var init_draggable     : * = fieldList[i++];
        initFieldCount = i;
        
        my_scalePoint = init_scalePoint;
    }
    
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================

    public override function handleContainerChanged() : void {
        my_sprite = new SFSprite().initOwner_scalePoint(this, my_scalePoint);
        
        
        if (my_costume.form != null) {
            my_sprite.setCostumeTo_rotationCenter(my_costume.form, my_costume.rotationCenter);
        } else {
            var graphics : Graphics = my_sprite.graphics;
            graphics.beginFill(0xFF4040);
            graphics.drawEllipse(my_costume.rotationCenter.x,my_costume.rotationCenter.y,my_costume.rotationCenter.x,my_costume.rotationCenter.y);
        }
        
        getStage().getCanvas().addChild(my_sprite);
        
        my_sprite.x = my_bounds.x;
        my_sprite.y = my_bounds.y;
        //moveSpriteToX_y(my_bounds.x, my_bounds.y); 
        
    }
    
    
}


}