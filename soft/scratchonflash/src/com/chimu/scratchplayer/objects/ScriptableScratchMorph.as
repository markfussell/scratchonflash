package com.chimu.scratchplayer.objects {
    import com.chimu.scratchplayer.blocks.EventHatBlock;
    import com.chimu.scratchplayer.execution.ScratchEvent;
    import com.chimu.scratchplayer.media.FilterPack;
    import com.chimu.scratchplayer.media.ImageMedia;
    import com.dynamicflash.util.Base64;
    
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    
    import mx.controls.Image;
    
    
/**
 * A ScriptableScratchMorph is the core entity of Scratch.
 * The parent class (a ScriptableObject) provides most of the generic
 * capabilities, but Scratch is highly visual and media oriented, so this 
 * class is the 'normal' class with two subclasses.
 * 
 * A ScriptableMorph is either a graphical Sprite or the 'frozen' Stage, and both 
 * can be shown on the stage in one of its 'costumes' and can draw on the stage
 * with a pen.
 * 
 * Finally a ScriptableMorph includes sound capabilities and potentially other
 * media that it can use.
 */
public class ScriptableScratchMorph extends ScriptableScratchObject {

    //My actual sprite on the screen.  
    //The 'Morph' is the logic behind this sprite... 
    //they are related by composition and delegation
    //vs. by inheritence
    protected var my_sprite : SFSprite;

    //Media is all media.  Sounds and costumes are specific types
    protected var my_media : Array;
    protected var my_costumes : Array;
    protected var my_sounds : Array;
    
    protected var my_costumeIndex : int;
    protected var my_costume : ImageMedia;
    
    /**
     * My current Image.  The Costume
     * modified as appropriate by rotations
     * and Filters/Effects.
     */
    protected var my_image : Image;
    
    protected var my_costumeChangeMSecs : *;
    protected var my_filterPack : FilterPack;
    protected var my_visibility : *;
    
    
    protected var my_volume : *;
    protected var my_tempoBPM : *;


    protected var my_bounds : Rectangle;

    
    static public function blockSpecs() : Array {
        var result : Array = new Array();
        
        //var exampleMorph : ScriptableScratchMorph = new ScriptableScratchMorph();
        //var exampleMorph2 : ScratchProcess = new ScratchProcess();
        
        //===============================================================
        //=== Looks
        
        result.push({label: "flip", type:"-", selector:"flip", eval: function() : void {this.flip(); } , defaultArgs: []});
        
        result.push({label: "switch to costume %l", type:"-", selector:"lookLike:", eval: function(costume:*) : void {this.lookLike(costume); } , defaultArgs: []});
        result.push({label: "next costume", type:"-", selector:"nextCostume", eval: function() : void {this.nextCostume(); } , defaultArgs: []});
        result.push({label: "costume #", type:"r", selector:"costumeIndex", eval: function() : Object {return this.costumeIndex(); } , defaultArgs: []});
        
        //===============================================================
        //=== Sound
        
        result.push({label: "play sound %S",            type:"-", selector:"playSound:", eval: function() : void {this.notYetImplemented("playSound:"); } , defaultArgs: []});
        result.push({label: "play sound %S until done", type:"s", selector:"doPlaySoundAndWait", eval: function() : void {this.notYetImplemented("doPlaySoundAndWait"); } , defaultArgs: []});
        result.push({label: "stop all sounds",          type:"-", selector:"stopAllSounds:", eval: function() : void {this.notYetImplemented("stopAllSounds:"); } , defaultArgs: []});
        
        //============
        result.push({label: "play drum %D for %n beats",    type:"t", selector:"drum:duration:elapsed:from:", eval: function() : void {this.notYetImplemented("drum:duration:elapsed:from:"); } , defaultArgs: [48,0.2]});
        result.push({label: "rest for %n beats",            type:"t", selector:"rest:elapsed:from:", eval: function() : void {this.notYetImplemented("rest:elapsed:from:"); } , defaultArgs: [0.2]});

        //============
        result.push({label: "play note %N for %n beats",    type:"t", selector:"noteOn:duration:elapsed:from:", eval: function() : void {this.notYetImplemented("noteOn:duration:elapsed:from:"); } , defaultArgs: [60, 0.5]});
        result.push({label: "set instrument to %I",         type:"-", selector:"midiInstrument:", eval: function() : void {this.notYetImplemented("midiInstrument:"); } , defaultArgs: [1]});

        //============
        result.push({label: "change volumen by %n",    type:"-", selector:"changeVolumeBy:", eval: function() : void {this.notYetImplemented("changeVolumeBy:"); } , defaultArgs: [-10]});
        result.push({label: "set volume to %n%",       type:"-", selector:"setVolumeTo:", eval: function() : void {this.notYetImplemented("setVolumeTo:"); } , defaultArgs: [100]});
        result.push({label: "volume",                  type:"r", selector:"volume", eval: function() : Object { return this.volume(); } , defaultArgs: []});

        //============
        result.push({label: "change tempo by %n",      type:"-", selector:"changeTempoBy:", eval: function() : void {this.notYetImplemented("changeTempoBy:"); } , defaultArgs: [20]});
        result.push({label: "set tempo to %n bpm",     type:"-", selector:"setTempoTo:", eval: function() : void {this.notYetImplemented("setTempoTo:"); } , defaultArgs: [60]});
        result.push({label: "tempo",                   type:"r", selector:"tempo", eval: function() : Object { return this.tempo(); } , defaultArgs: []});

        //===============================================================
        //=== Pen
        
        result.push({label: "clear", type:"-", selector:"clearPenTrails", eval: function() : void {this.clearPenTrails(); } , defaultArgs: []});

        //===============================================================
        //=== Sensing

        result.push({label: "mouse x", type:"r", selector:"mouseX", eval: function() : Object {return this.notYetImplementedValue("mouseX"); } , defaultArgs: []});
        result.push({label: "mouse y", type:"r", selector:"mouseY", eval: function() : Object {return this.notYetImplementedValue("mouseY"); } , defaultArgs: []});
        result.push({label: "mouse down?", type:"b", selector:"mousePressed", eval: function() : Object {return this.notYetImplementedValue("mousePressed"); } , defaultArgs: []});

        //============

        result.push({label: "key %k pressed?", type:"b", selector:"keyPressed", eval: function() : Object {return this.notYetImplementedValue("keyPressed"); } , defaultArgs: ["space"]});

        //============

        result.push({label: "reset timer", type:"-", selector:"timerReset", eval: function() : void {this.notYetImplementedValue("timerReset"); } , defaultArgs: []});
        result.push({label: "timer", type:"r", selector:"timer", eval: function() : Object {return this.notYetImplementedValue("timer"); } , defaultArgs: []});

        //============

        result.push({label: "%a of %m", type:"r", selector:"getAttribute:of:", eval: function() : Object {return this.notYetImplementedValue("getAttribute:of:"); } , defaultArgs: []});

        //============
        
        result.push({label: "loudness", type:"r", selector:"soundLevel", eval: function() : Object {return this.notYetImplementedValue("soundLevel"); } , defaultArgs: []});
        result.push({label: "loud?", type:"b", selector:"isLoud", eval: function() : Object {return this.notYetImplementedValue("isLoud"); } , defaultArgs: []});

        //============

        result.push({label: "%H sensor value", type:"r", selector:"sensor:", eval: function() : Object {return this.notYetImplementedValue("sensor:"); } , defaultArgs: ["slider"]});
        result.push({label: "sensor %h", type:"b", selector:"sensorPressed:", eval: function() : Object {return this.notYetImplementedValue("sensorPressed:"); } , defaultArgs: ["button pressed"]});

        
        return result;
    }


    //=========================================================
    //=========================================================
    //=========================================================


    public function handleContainerChanged() : void {
        //might do the submorph thing here...
    }


    public function reactToMouseDown(event : MouseEvent) : Boolean {
        var wasHit : Boolean = my_sprite.hitTestPoint(event.stageX, event.stageY);
        
        if (wasHit) {
            var scratchEvent : ScratchEvent = new ScratchEvent().initType_name_argument(EventHatBlock.CONST_MouseClickEvent, EventHatBlock.CONST_MouseClickEvent, event);
            broadcastEventToSelf_addTo(scratchEvent, new Array());
            return true;
        }
        
        return false;
        
    }

    //=========================================================
    //=========================================================
    //=========================================================





    public function tempo() : * {
        return my_tempoBPM;
    }


    public function volume() : * {
        return my_volume;
    }


    public function flip() : void {
        //costume form: ...
    }
    
    //=========================================================
    //=========================================================
    //=========================================================

    

    public function drum_duration_elapsed_from(midiKey : *, beats : *, elapsedMSecs : *, notPlayer : *) : void {
        //Implement the drum/midi capabilities [these are time based]
        
        return;
    }
    

    //=========================================================
    //=========================================================
    //=========================================================

    
    public function createTestImage() : void {
        var bytes : ByteArray = new ByteArray();
        //var base64 : Base64 = new Base64();
        bytes.writeObject({foo:"Foo",bar:1});
        var result1 : String = Base64.encode("This is a test");
    }


    public function createImageFrom(bytes : ByteArray) : void {
        var loader : Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleLoaderComplete);
        loader.loadBytes(bytes);
        
        /*
        loader.content
        var bitmap : BitmapData = new BitmapData();
        var result : Image = new Image();
        result.load(bytes);
        var jpeg : JPEGEncoder;
        var converter :
        */
        
         
    }

    protected function handleLoaderComplete(event : Event) : void {
        var loader:Loader = event.target as Loader;
        var bmp:Bitmap = (loader.content as Bitmap);
        //bmp.
    }


    /**
     * Ideally the initFields would be divided between the 'Object' and the 'Morph'/Sprite
     * but the Smalltalk serialization makes that non-sensical.
     */
    protected override function initFieldsFrom_version_UseCounter(fieldList : Array, classVersion : Number) : void {
        super.initFieldsFrom_version_UseCounter(fieldList, classVersion);
        
        /**
        * bounds, owners, submorphs, color, flags, properties
        * objName, vars, blocksBin, isClone, media, costume
        */
        
        var i : int = initFieldCount;
        var init_bounds     : * = fieldList[i++];
        var init_owners     : * = fieldList[i++];
        var init_submorphs  : * = fieldList[i++];
        var init_color      : * = fieldList[i++];
        var init_flags      : * = fieldList[i++];
        var init_properties : * = fieldList[i++];
        var init_objName   : * = fieldList[i++];
        var init_vars      : * = fieldList[i++];
        var init_blocksBin : * = fieldList[i++];
        var init_isClone   : * = fieldList[i++];
        var init_media     : * = fieldList[i++];
        var init_costume   : * = fieldList[i++];
   
        my_bounds = init_bounds;
        my_objName = init_objName;
        my_vars = init_vars;
        my_submorphs = (init_submorphs as Array).filter(function (eachEntry : *, index : int, array:Array) : Boolean {return (eachEntry != null)});
        my_media = init_media;
        my_costume = init_costume;
        my_costumes = my_media.filter(function (eachEntry : *, index : int, array:Array) : Boolean {return (eachEntry is ImageMedia)});
        
        //Will expand this later after all information is ready
        my_blocksBin = init_blocksBin;
        
        initFieldCount = i;
    }
    
    //===========================================
    //=== Movie Ops
    //===========================================

    public function startPlaying() : void {
        //my_costume.startPlaying
        //movieChanged
    }

    //===========================================
    //=== Looks Ops
    //===========================================

    public function changeCostumeIndexBy(n : Number) : void {
        setCostumeIndex(my_costumeIndex + n); 
    }
    
    public function setCostumeIndex(n : Number) : void {
        if (my_costumes.length < 1) return;
        
        if (n >= my_costumes.length) {
            n = n % my_costumes.length;
        }
        
        if (n < my_costumes.length) {
            lookLike((my_costumes[n] as ImageMedia).mediaName);
        };
    }
    
    public function nextCostume() : void {
        changeCostumeIndexBy(1);
    }
    
    public function costumeIndex() : Object {
        return my_costumeIndex;
    }
    
    public function lookLike(mediaName : String) : void {
        var p : Point = getReferencePosition();
        
        var index : Number = -1;
        for (var i:int=0; i<my_costumes.length; i++) {
            if ( (my_costumes[i] as ImageMedia).mediaName == mediaName) {
                index = i;
                break;        
            }
        } 
        if (index < 0) return;
        
        my_costume = my_costumes[i];
        my_costume.resumePlaying();
        noteCostumeChanged();
        
        setReferencePosition(p);
        
        //World... displaySafely?
    }

    protected function noteCostumeChanged() : void {
        if (my_filterPack != null) {
            my_filterPack.clearFilterCaches();
        }
        
        layoutChanged();
    } 
    
    protected function layoutChanged() : void {
        //Don't do anything by default?
        //But the SpriteMorph may adjust position for the new costume? 
    }

    public function visibility() : Number {
        return my_sprite.alpha * 100;
    }
    
    public function setVisibility(visibility : Number) : void {
        my_sprite.alpha = (visibility / 100);
    }
    
    public function transparency() : Number {
        return 100 - visibility();
    }
    
    public function setTransparency(transparency : Number) : void {
        setVisibility(100-transparency);
    }
    
    public function setVisibilityRounded(visibility : Number) : void {
        setVisibility(Math.round(visibility));
    }
    
    public function isPenDown() : Boolean {
        return false;
    } 

    //===================================================================================================
    //===================================================================================================
    //===================================================================================================
    //=== Pens

    public function clearPenTrails() : void {
        getStage().clearPenTrails();
    }

    
    //=====================================================
    //=====================================================
    //=====================================================
    
    //Should be the center of my sprite
    protected function getReferencePosition() : Point {
        var r : Rectangle = my_sprite.getBounds(getStage().getSprite());
        var p : Point = new Point((r.x + r.width/2), (r.y + r.height/2));
        return p;
    }
    
    public function getSprite() : Sprite {
        return my_sprite;
    }
    
    /**
     * Set my reference (center) position.  Keep on stage (I believe?)
     */
    protected function setReferencePosition(aPoint : Point) : void {
        var x : Number = aPoint.x;
        var y : Number = aPoint.y;
        
        if (x == Number.NEGATIVE_INFINITY) {
            x = 0;
        }
        
        //...
    }
    

    //=======================================================================
    //=======================================================================
    //=======================================================================

    public function filteredForm() : Image {
        if (my_filterPack == null) return rotatedForm();
        
        if (my_filterPack.needToApplyFilters()) {
            my_filterPack.applyFiltersTo(rotatedForm());
        }
        
        return my_filterPack.resultForm;
    }
    
    protected function rotatedForm() : Image {
        return null;
    }
    
    //=======================================================================
    //=======================================================================
    //=======================================================================
    
    
}


}