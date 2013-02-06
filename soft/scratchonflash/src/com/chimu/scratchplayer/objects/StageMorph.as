package com.chimu.scratchplayer.objects {
    import com.chimu.scratchplayer.app.StageContainer;
    import com.chimu.scratchplayer.blocks.EventHatBlock;
    import com.chimu.scratchplayer.execution.ScratchEvent;
    import com.chimu.scratchplayer.execution.ScratchProcess;
    import com.chimu.scratchplayer.execution.ScratchScheduler;
    import com.chimu.scratchplayer.translation.ScratchTranslatorLib;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import mx.containers.Canvas;
    import mx.controls.Image;
    import mx.core.Container;
    import mx.core.UIComponent;
    

/**
 * A StageMorph is the singleton owner of the Stage and
 * all the Sprites that play on that Stage.
 * 
 * The Stage also maintains pen trails and stamps:
 * 
 * Was: ScratchStageMorph (I just dropped the 'Scratch' prefix)
 */
public class StageMorph extends ScriptableScratchMorph {
    
    public function StageMorph() {
        scheduler = new ScratchScheduler();
        scheduler.initStage(this);
    }

    public var scheduler : ScratchScheduler;
    protected var my_stageContainer : StageContainer;
    
    public function initFlashContainer(container : StageContainer) : StageMorph {
        my_stageContainer = container;
        
        handleContainerChanged();
        
        return this;
    } 
    
    
    public function getCanvas() : Canvas {
        return my_canvas;
    }
    
    protected var my_canvas : Canvas = null;
    
    static protected const CONST_backgroundLayer : int = 0;
    static protected const CONST_penTrailsLayer : int = 1;
    
    public override function handleContainerChanged() : void {
        var canvas : Canvas = my_stageContainer.getStageCanvas();
        my_canvas = new Canvas();
        canvas.addChild(my_canvas);

        if (my_costume != null) {
            var background : Image = new Image();
            var bitmap : Bitmap = new Bitmap(my_costume.form);
            background.source = bitmap;
            my_canvas.addChildAt(background,CONST_backgroundLayer);
        } else {
            var graphics : Graphics = my_canvas.graphics;

            graphics.beginFill(0xFFFFFF);
            graphics.drawCircle(10,10,10);
        }
        
        clearPenTrails();
        
        for each (var submorph : ScriptableScratchMorph in my_submorphs) {
            submorph.handleContainerChanged();
        }
    }
    
    
    //===================================================================================================
    //=== Pen
    //===================================================================================================

    /**
     * Implementing Pen behavior is a bit interesting because we could choose 
     * to be fairly sophisticated (individual layers for each sprite) without
     * much effort.  But to keep things consistent with the behavior
     * of Scratch in Squeak, there will be a single Canvas and only
     * that Canvas's graphics layer will be drawn on.
     * 
     * Unfortunately (or at least incongruently), Flash doesn't really use 
     * bitmap graphics by default, so we have a bit of incompatibility
     * between the two models.  As a first pass, all line drawings for
     * Scratch are done into a 'pen layer', and all bitmaps stamps are done
     * into their own layer.  So a complex drawing could have many, many
     * layers if they alternate the two.
     * 
     * If the memory issue for this becomes prohibative, we could flatten 
     * all the previous pen/bitmap layers into a single Bitmap with a 
     * 'BitmapData::draw'.  Maybe after every dozen or so layers.
     */

    /**
     * Clear the pen trails graphics layer
     */
    public override function clearPenTrails() : void {
        //Always above the background, although the ordering makes that true as well
        var penTrailLayer : int = CONST_penTrailsLayer; 
        if (my_penTrails != null) {
            penTrailLayer = my_canvas.getChildIndex(my_penTrails);
            
            my_penTrails.removeAllChildren();
            my_canvas.removeChild(my_penTrails);
            my_penTrails = null;
        } 
        
        my_penTrails = new Canvas();
        my_penTrails.clipContent = false;
        my_canvas.addChildAt(my_penTrails, penTrailLayer);

        /*
        stampBitmap_onto_at(my_costume.form, my_penTrails, new Point(-50,-30));
        
        var graphics : Graphics = getCurrentPenGraphics();
        graphics.beginFill(0xFF0000);
        graphics.drawCircle(10,10,10);
        graphics.endFill();

        graphics.lineStyle(2,0x0000FF);
        graphics.moveTo(5,5);
        graphics.lineTo(30,50);
        */
    }
    
    public function drawLineFrom_to_size_color(fromPoint : Point, toPoint : Point, size : Number, color : uint) : void {
        var graphics : Graphics = getCurrentPenGraphics();
        graphics.lineStyle(size, color);
        graphics.moveTo(fromPoint.x, fromPoint.y);
        graphics.lineTo(toPoint.x, toPoint.y);
    }
    
    protected function getCurrentPenGraphics() : Graphics {
        if (my_currentPenLayer == null) {
            my_currentPenLayer = new UIComponent();
            my_penTrails.addChild(my_currentPenLayer);
        }
        return my_currentPenLayer.graphics;
    }
    
    protected var my_currentPenLayer : UIComponent = null;

    protected function startNewPenLayer() : void {
        my_currentPenLayer = null;
    }


    public function stampCostumeForSprite(sprite : SFSprite) : void {
        startNewPenLayer();
        
        var stampSprite : SFSprite = new SFSprite();
        my_penTrails.addChild(stampSprite);
        
        stampSprite.copyFromSprite(sprite);
        stampSprite.x = sprite.x;
        stampSprite.y = sprite.y;

        
        /*
        var costume : Image = sprite.getCurrentCostume();
        var currentAppearance : BitmapData = new BitmapData(costume.width, costume.height);
        currentAppearance.draw(costume);
        var location : Point = new Point(sprite.x, sprite.y); //sprite.getPosition();
        stampBitmap_onto_at(currentAppearance, my_penTrails, location);
        */
    }

    /**
     * Filling onto the graphics, but maybe should just stamp with a child BitmapImage
     */
    protected function stampBitmap_onto_at(costumeData : BitmapData, component : Container, location : Point) : void {
        // Need to clear the pen layer, so the next draw will be above us
        startNewPenLayer();
        
        var newStamp : Image = new Image();
        var bitmap : Bitmap = new Bitmap(costumeData);
        newStamp.source = bitmap;
        newStamp.x = location.x;
        newStamp.y = location.y;
        component.addChild(newStamp);
        
        /*
        var graphics : Graphics = component.graphics;

        graphics.beginFill(0x00FF00);
        graphics.drawRect(location.x, location.y, costumeData.width, costumeData.height);
        graphics.endFill();


        var filler : BitmapFill = new BitmapFill();
        filler.source=costumeData;
        filler.begin(graphics, new Rectangle(0,0,costumeData.width/2, costumeData.height));
        graphics.moveTo(5,5);
        graphics.lineTo(30,50);
        filler.end(graphics);
        */
    }
    
    
    
    protected var my_penTrails : Canvas = null;
    
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================
    
    static public function blockSpecs() : Array {
        var result : Array = new Array();
        
        //===============================================================
        //=== Motion
        
        //===============================================================
        //=== Sensing
        
        //===============================================================
        //=== Looks
        
        result.push({label: "switch to background %l", type:"-", selector:"showBackground:", eval: function() : void {this.notYetImplementedValue("showBackground:"); } , defaultArgs: ["background1"]});
        result.push({label: "next background", type:"-", selector:"nextBackground:", eval: function() : void {this.notYetImplementedValue("nextBackground"); } , defaultArgs: []});
        result.push({label: "background #", type:"r", selector:"backgroundIndex", eval: function() : Object {return this.notYetImplementedValue("backgroundIndex"); } , defaultArgs: []});
        
        //===============================================================
        
        return result;
    }
    

    
    /**
     * Update the pen trails form using the current positions of all sprites with their pens down
     */
    public function updateTrailsForm() : void {
        //MLF: Actually, I don't think this needs to do anything in the Flash implementation
        //notYetImplemented("updateTrailsForm");
    }


    public function startProcessForStatements(blockList : Array) : ScratchProcess {
        return scheduler.startProcessForStatements(blockList);
    }
    
    
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
        var init_zoom      : * = fieldList[i++];
        var init_hPan      : * = fieldList[i++];
        var init_vPan      : * = fieldList[i++];
        var init_obsolete  : * = fieldList[i++];
        var init_sprites   : * = fieldList[i++];
        var init_volume    : * = fieldList[i++];
        var init_tempBPM   : * = fieldList[i++];
        initFieldCount = i;
    }
    
    protected override function doneInitializeFields() : void {
        my_stage = this;
        
        for each (var submorph : ScriptableScratchMorph in my_submorphs) {
            submorph.setupStage(this);
        }
        
        super.doneInitializeFields();
    }

    
    public function toString() : String {
        return "<Stage id="+my_objName+" blocksBins="+(my_blocksBin == null ? "0" : my_blocksBin.length)+" submorphs#="+(my_submorphs == null ? "0" : my_submorphs.length)+" >";
    }
    
    
    //=========================================================
    //=========================================================
    //=========================================================
    
    public function handleStartClicked() : void {
        broadcastCustomEventNamed_with(EventHatBlock.CONST_StartClickedEvent,null);
    }
    
    
    public function getLastMousePosition() : Point {
        if (my_lastMouseEvent == null) return null;
        
        return my_canvas.globalToLocal(new Point(my_lastMouseEvent.stageX, my_lastMouseEvent.stageY)); 
    }
    
    protected var my_lastMouseEvent : MouseEvent = null;
    public function handleMouseEvent(event : MouseEvent) : void {
        my_lastMouseEvent = event;
    }
    
    public function handleMouseDownEvent(event : MouseEvent) : void {
        //logInfo("Mousie: x="+event.localX+" y="+event.localY+" down="+event.buttonDown);//+" other="+event);
        my_lastMouseEvent = event;
        
        //Upon whom did they click?
        var hitSprite : Boolean = false;
        for each (var submorph : ScriptableScratchMorph in my_submorphs) {
            //Do it this way so all submorphs get a chance to be hit (say they are both on the same location)
            hitSprite = submorph.reactToMouseDown(event) || hitSprite;
        }
        
        if (!hitSprite) {
            var scratchEvent : ScratchEvent = new ScratchEvent().initType_name_argument(EventHatBlock.CONST_MouseClickEvent, EventHatBlock.CONST_MouseClickEvent, event);
            broadcastEventToSelf_addTo(scratchEvent, new Array());
        }
    }
    
    public function handleMouseUpEvent(event : MouseEvent) : void {
        my_lastMouseEvent = event;
    }
    
    
    protected var my_lastKeyEvent : KeyboardEvent = null;
    public function handleKeyDown(event : KeyboardEvent) : void {
        //logInfo("Keyboard: char="+event.charCode+" type="+event.type+" alt="+event.altKey+" other="+event);//);
        broadcastEventType_named_with(EventHatBlock.CONST_KeyPressedEvent, getKeyEventString(event), event);
        my_lastKeyEvent = event;
    }
    
    protected function getKeyEventString(event : KeyboardEvent) : String {
        var charCode : int = event.charCode;
        if (charCode > 0) return String.fromCharCode(charCode);
        return ScratchTranslatorLib.longNameFromKeyCode(event.keyCode);
    }
    
    public function handleKeyUp(event : KeyboardEvent) : void {
        //logInfo("Keyboard: char="+event.charCode+" type="+event.type+" alt="+event.altKey);//+" other="+event);
        my_lastKeyEvent = event;
    }
}


}