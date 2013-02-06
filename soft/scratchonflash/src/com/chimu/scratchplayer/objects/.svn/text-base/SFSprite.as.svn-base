package com.chimu.scratchplayer.objects {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Transform;
    
    import mx.containers.Canvas;
    import mx.controls.Image;
    import mx.events.FlexEvent;
    

/**
 * An SFSprite (short for ScratchFlashSprite) is a scratch-aware
 * graphical flash sprite.  It is mainly used to support
 * the coordinate change, move-from-center, scaling, etc. behavior 
 * associated with ScratchSprites.  It is not meant to be
 * Scratch-intelligent (see the SpriteMorph for that) but
 * understands the graphical issues/difference with Scratch
 * 
 * The biggest issues for a SFSprite is dealing with coordinate
 * system changes, correct positioning of think elements, 
 * and being able to support the 'filters' / effects that
 * are coming from Scratch. 
 * 
 * 
 * Note this is a Canvas solely for debugging
 * purposes (like putting a borderStyle on it). 
 */
public class SFSprite extends Canvas {
    protected var my_owner : SpriteMorph;


    protected var my_scalePoint : Point;
    protected var my_originalSize : Point;
    protected var my_scratchPosition : Point;
    protected var my_scaleValue : Number = 1.0;

    protected var my_directionDegrees : int = 0;
    
    protected var my_currentCostumeBitmap : BitmapData;
    protected var my_rotationCenter : Point;

    protected var my_currentCostume : Image;

    //===================================================================================================
    //===================================================================================================
    //===================================================================================================
    //=== Pen related properties.   
    //=== Ideally, this would be a separate class (either the whole thing or at least the properties
    
    protected var my_penSize : Number = 1;
    protected var my_penColor : uint = 0x000000;
    protected var my_isPenDown : Boolean = false;
    protected var my_lastPenPoint : Point = null;

    
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================

    public function SFSprite() {
        this.clipContent=false;
        this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
    }

    protected function handleCreationComplete(event : FlexEvent = null) : void {
        //this.setStyle("borderStyle","solid");
        //this.setStyle("borderThickness","2");
    }

    public function copyFromSprite(oldSprite : SFSprite) : SFSprite {
        my_scalePoint = oldSprite.my_scalePoint;
        my_originalSize = oldSprite.my_originalSize;
        my_scratchPosition = oldSprite.my_scratchPosition;
        my_scaleValue = oldSprite.my_scaleValue;
        
        my_directionDegrees = oldSprite.my_directionDegrees;
        
        setCostumeTo_rotationCenter(oldSprite.my_currentCostumeBitmap, oldSprite.my_rotationCenter);
        
        return this;
    }

    //===================================================================================================
    //===================================================================================================
    //===================================================================================================

    public function initOwner_scalePoint(owner : SpriteMorph, scalePoint : Point) : SFSprite {
        my_owner = owner;
        my_scalePoint = scalePoint;
        return this;
    }

    public function setCostumeTo_rotationCenter(bitmapdata : BitmapData, rotationCenter : Point) : void {
        if (my_currentCostume != null) {
            removeChild(my_currentCostume);
            my_currentCostume = null;
        }
        
        my_currentCostumeBitmap = bitmapdata;
        my_rotationCenter = rotationCenter;
        
        var bitmap : Bitmap = new Bitmap(bitmapdata);
        var subimage : Image = new Image();
        subimage.source = bitmap;
        
        my_currentCostume = subimage;
        addChild(subimage);
        
        redrawCostumeWithScaleAndRotation();
    }
    
    
    //========================================================
    //========================================================
    //========================================================
    
    public function getCurrentCostume() : Image {
        return my_currentCostume;
    }

    protected function getCurrentWidth() : Number {
        return my_currentCostume.width;// * my_scaleValue;  //MLF: We no longer are changing outer bounding box size 
    }
    
    protected function getCurrentHeight() : Number {
        return my_currentCostume.height;// * my_scaleValue;
    }
    
    //========================================================
    //========================================================
    //========================================================
    

    public function forward(distance : Number) : void {
        var degrees : Number = my_directionDegrees;
		var radianAngle : Number = Math.PI * degrees / 180;
        
		var xFactor:Number = Math.cos( radianAngle );
        var yFactor:Number = Math.sin( radianAngle );
		
		var xChange : Number = distance * xFactor;
		var yChange : Number = distance * yFactor;
		
		var currentPos : Point = getPosition();
		
		var newX : Number = currentPos.x + xChange;
		var newY : Number = currentPos.y + yChange;
		
        moveToX_y(newX,newY);
    }
    
    
    public function turnRight(degrees : Number) : void {
        my_directionDegrees -= degrees;
        
        redrawCostumeWithScaleAndRotation();
    }
    

    public function turnLeft(degrees : Number) : void {
        my_directionDegrees += degrees;

        redrawCostumeWithScaleAndRotation();
    }
    
    public function heading(degrees : Number) : void {
        my_directionDegrees = degrees;

        redrawCostumeWithScaleAndRotation();
    }
    
    public function headTowards_FXY(point : Point) : void {
        var deltaX : Number = point.x - this.x;
        var deltaY : Number = point.y - this.y;
        
        var angle : Number = 0;
        if (Math.abs(deltaX) < 0.001) {
            angle = (deltaY < 0) ? 90 : 270;
        } else {
            angle = -Math.atan2(deltaY,deltaX) * 180 / Math.PI;
        }
        
        my_directionDegrees = angle;
        redrawCostumeWithScaleAndRotation();
    }
    

    public function moveTo_FXY(point : Point) : void {
        moveToX_y(flashXtoScratch(point.x), flashYtoScratch(point.y));
    }
    
    

    public function gotoX_y(x : Number, y:Number) : void {
        moveToX_y(x,y);
    }
    
    public function moveToX_y(newX : Number, newY : Number) : void {
        drawPenTo(newX, newY);
        
        this.x = scratchXtoFlash(newX);
        this.y = scratchYtoFlash(newY);
    }

    protected function getStage() : StageMorph {
        if (my_owner == null) return null;
        
        return my_owner.getStage();
    }


    public function putPenDown() : void {
        my_isPenDown = true;
    }
    
    public function putPenUp() : void {
        my_isPenDown = false;
    }
    

    public function setPenColor(color : *) : void {
        my_penColor = color.rgb;
        //my_sprite.setPenColor(color);
    }
    
    public function setPenSize(size : *) : void {
        my_penSize = size;
        if (my_penSize < 0) {
            my_penSize = 0;
        }
    }
    
    public function changePenSizeBy(a : *) : void {
        setPenSize(my_penSize + a);
    }
    


    protected function createPenPointFor(x : Number, y : Number) : Point {
        var newX : Number = scratchXtoFlash(x);
        var newY : Number = scratchYtoFlash(y);
        
        var penPositionX : Number = newX + my_currentCostume.x;// + (getCurrentWidth() / 2);
        var penPositionY : Number = newY + my_currentCostume.y;// + (getCurrentHeight() / 2);
        
        return new Point(penPositionX, penPositionY);
    }

    public function drawPenTo(newX : Number, newY : Number) : void {
        var lastPenPoint : Point = my_lastPenPoint;
        
        var newPenPoint : Point = createPenPointFor(newX, newY);
        my_lastPenPoint = newPenPoint;
        
        //Now decide whether to draw
        if (!my_isPenDown) return;
        if (my_owner == null) return;
        
        if (lastPenPoint == null) {
            var scratchPoint : Point = getPosition();
            lastPenPoint = createPenPointFor(scratchPoint.x, scratchPoint.y);
        }
        
        getStage().drawLineFrom_to_size_color(lastPenPoint, newPenPoint, my_penSize, my_penColor);
   }


    public function getPosition() : Point {
        return new Point(flashXtoScratch(this.x), flashYtoScratch(this.y));
    }

    public function getPosition_FXY() : Point {
        return new Point(this.x, this.y);
    }

    public function getPosition_SXY() : Point {
        return new Point(flashXtoScratch(this.x), flashYtoScratch(this.y));
    }

    public function getHeading() : Number {
        return my_directionDegrees;
    }
    
    
    //=========================
    //=========================
    //=========================

    public function setXpos(x : Number) : void {
        moveToX_y(x,getPosition().y);
    }
    
    public function setYpos(y : Number) : void {
        moveToX_y(getPosition().x,y);
    }
    
    public function changeXposBy(a : Number) : void {
        moveToX_y(getPosition().x+a,getPosition().y);
    }
    
    public function changeYposBy(a : Number) : void {
        moveToX_y(getPosition().x,getPosition().y+a);
    }
    
    /**
     * If I am outside the display area, then bounce.
     * Algorithm: flip the direction of my vector on any side that is going 
     * the wrong way.
     */
    public function bounceOffEdge() : void {
        var myBox : Rectangle = getCostumeBounds_SXY();
        
        if (CONST_stageRect_SXY.containsRect(myBox)) return;

        var headingRadians : Number = my_directionDegrees * Math.PI / 180;
        var dirX : Number =  Math.cos(headingRadians);
        var dirY : Number =  Math.sin(headingRadians);
        
        //trace("Before: "+my_directionDegrees+" x:"+dirX+" y:"+dirY);
        
        if (myBox.left < CONST_stageRect_SXY.left) dirX = Math.abs(dirX);
        if (myBox.right > CONST_stageRect_SXY.right) dirX = -Math.abs(dirX);
        if (myBox.top < CONST_stageRect_SXY.top) dirY = Math.abs(dirY);
        if (myBox.bottom > CONST_stageRect_SXY.bottom) dirY = -Math.abs(dirY);
        
        my_directionDegrees = Math.atan2(dirY, dirX) * 180 / Math.PI;

        //trace("After: "+my_directionDegrees+" x:"+dirX+" y:"+dirY);
        
        redrawCostumeWithScaleAndRotation();
        //
    }
    
    //SXY = ScratchXY coordinates
    protected function getCostumeBounds_SXY() : Rectangle {
        var position : Point = getPosition();
        return new Rectangle(position.x, position.y, 1, 1);
    }
    
    
    //========================================================
    //========================================================
    //========================================================
    //MLF: This is all statically coded to be compatible with the
    //Scratch model

    static protected const CONST_stageCoordinateCenterX : int = 240;
    static protected const CONST_stageCoordinateCenterY : int = 180;

    static protected const CONST_stageWidth  : int = CONST_stageCoordinateCenterX * 2;
    static protected const CONST_stageHeight : int = CONST_stageCoordinateCenterY * 2;
    
    static protected const CONST_stageRect_Flash : Rectangle = new Rectangle(0,0,CONST_stageWidth, CONST_stageHeight);
    static protected const CONST_stageRect_SXY : Rectangle = new Rectangle(-CONST_stageCoordinateCenterX, -CONST_stageCoordinateCenterY, CONST_stageWidth, CONST_stageHeight);


    // transX = Center + x
    // transY = Center - y
    
    // stageX = scratchCenterX + (x - centerX)
    // x = stageX - scratchCenterX + centerX
    // stageY = scratchCenterY - y - centerY
    // y = scratcCenterY - stageY + centerY
 
    protected function scratchXtoFlash(newX : Number) : Number {
        return CONST_stageCoordinateCenterX + (newX - (getCurrentWidth() / 2));
    }
 
    protected function scratchYtoFlash(newY : Number) : Number {
        return CONST_stageCoordinateCenterY - newY - (getCurrentHeight() / 2);
    }
    
    protected function flashXtoScratch(newX : Number) : Number {
        return -CONST_stageCoordinateCenterX + (newX + (getCurrentWidth() / 2));
    }

    protected function flashYtoScratch(newY : Number) : Number {
        return CONST_stageCoordinateCenterY - newY - (getCurrentHeight() / 2);
    }
 
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================

    public function changeSizeBy(by : Number) : void {
        my_scaleValue += (by / 100);
        
        redrawCostumeWithScaleAndRotation();
    }
        
    public function setSizeTo(value : Number) : void {
        my_scaleValue = value / 100;
        
        redrawCostumeWithScaleAndRotation();
    }
    
    
    public function show() : void {
        this.visible=true;
    }
    
    public function hide() : void {
        this.visible=false;
    }
    
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================

    protected function redrawCostumeWithScaleAndRotation() : void {
        var transform : Transform = my_currentCostume.transform;

        //Start over with a new matrix because these transformations are not cumulative
        var matrix : Matrix = new Matrix();
        var scaling : Number = my_scaleValue;
        var x : Number = 0;
        var y : Number = 0;
        var rotationCenter : Point = getFlashRotationCenter();
        if (rotationCenter != null) {
            x = rotationCenter.x; // vs. scalePoint? 
            y = rotationCenter.y; //
        }
        scaleAroundInternalPoint(matrix, x, y, scaling, scaling);
        rotateAroundInternalPoint(matrix, x, y, Math.PI * getFlashRotation() / 180);
        
        my_currentCostume.transform.matrix = matrix;
    }
    
    /**
     * Because the coordinate system is flipped, rotations are also reversed
     */
    protected function getFlashRotation() : Number {
        return -my_directionDegrees; 
    }
    
    protected function getFlashRotationCenter() : Point {
        if (my_rotationCenter == null) return null;
        
        return my_rotationCenter;
    }

    protected function scaleAroundInternalPoint(m:Matrix, x:Number, y:Number, scaleX:Number, scaleY:Number):void     {
        var point:Point = new Point(x, y);
        point = m.transformPoint(point);
        m.tx -= point.x;
        m.ty -= point.y;
        m.scale(scaleX,scaleY);
        m.tx += point.x;
        m.ty += point.y;
    }
            
    protected function rotateAroundInternalPoint(m:Matrix, x:Number, y:Number, rotation:Number):void     {
        var point:Point = new Point(x, y);
        point = m.transformPoint(point);
        m.tx -= point.x;
        m.ty -= point.y;
        m.rotate(rotation);
        m.tx += point.x;
        m.ty += point.y;
    }
            
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================

    static protected const CONST_EffectType_color : String = "color";
    public function changeGraphicEffect_by(effect : String, by : Number) : void {
        if (effect == CONST_EffectType_color) {
            
            var transform : Transform = this.transform;
            //http://keywon.com/wiki/index.php?title=ColorMatrix
            //ColorMatrixFilter
            //var rOffset:Number = transform.colorTransform.redOffset + (5 * by);
            //var bOffset:Number = transform.colorTransform.blueOffset - (5 * by);
            //transform.colorTransform = new ColorTransform(1, 1, 1, 1, by, by, by, 0);
            
            applyAdjustHue_to(by, my_currentCostume);
        }
    }
    
    
    
    //===================================================================================================
    //===================================================================================================
    //===================================================================================================

    
    private function applyBlueTo(child:DisplayObject):void {
        var matrix:Array = new Array();
        matrix = matrix.concat([0, 0, 0, 0, 0]); // red
        matrix = matrix.concat([0, 0, 0, 0, 0]); // green
        matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
        matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha

        applyFilterTo_matrix(child, matrix);
    }
    
	public function applyAdjustHue_to(angle:Number, child: DisplayObject):void {
		angle = Math.PI * (angle * 1.8) / 180; //* Math.PI/180;
		
		var c:Number = Math.cos( angle );
        var s:Number = Math.sin( angle );
		
        var f1:Number = 0.213;
        var f2:Number = 0.715;
        var f3:Number = 0.072;
		
        var matrix:Array = [(f1 + (c * (1 - f1))) + (s * (-f1)), (f2 + (c * (-f2))) + (s * (-f2)), (f3 + (c * (-f3))) + (s * (1 - f3)), 0, 0, (f1 + (c * (-f1))) + (s * 0.143), (f2 + (c * (1 - f2))) + (s * 0.14), (f3 + (c * (-f3))) + (s * -0.283), 0, 0, (f1 + (c * (-f1))) + (s * (-(1 - f1))), (f2 + (c * (-f2))) + (s * f2), (f3 + (c * (1 - f3))) + (s * f3), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
		var applyMatrix : Array = concat(matrix, IDENTITY);
		
        applyFilterTo_matrix(child, matrix);
	}
    
    
    private static var IDENTITY:Array = [1,0,0,0,0,
                                          0,1,0,0,0,
                                          0,0,1,0,0,
                                          0,0,0,1,0];

    public function concat(mat:Array, oldMat: Array):Array  {
        
        var temp:Array = new Array();
        var i:Number = 0;
        
        for (var y:Number = 0; y < 4; y++ )
        {
            
            for (var x:Number = 0; x < 5; x++ )
            {
                temp[i + x] = mat[i    ] * oldMat[x     ] + 
                               mat[i+1] * oldMat[x +  5] + 
                               mat[i+2] * oldMat[x + 10] + 
                               mat[i+3] * oldMat[x + 15] +
                               (x == 4 ? mat[i+4] : 0);
            }
            i+=5;
        }
        
        return temp;
        
    }

    private function applyFilterTo_matrix(child:DisplayObject, matrix:Array):void {
        var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
        var filters:Array = new Array();
        filters.push(filter);
        child.filters = filters;
    }

    
}


}