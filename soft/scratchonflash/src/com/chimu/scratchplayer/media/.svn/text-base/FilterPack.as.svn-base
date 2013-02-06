package com.chimu.scratchplayer.media {
    import mx.controls.Image;
    
    

/**
 * A FilterPack changes the costume (image)
 * of the sprite by applying various visual effects.
 * 
 * This is potentially a problematic class with Flash
 * but we will see.
 */
public class FilterPack {
    public var resultForm : Image = null;
    public var cachedForm : Image = null; 
    
    public var reapply : Boolean = false;
    
    public var brightnessShift : int = 0;
    public var saturationShift : int = 0;
    public var hueShift : int = 0;
    
    public var mosaicCount : int = 0;
    public var pixelateCount : int = 0;
    public var fisheye : int = 0;
    public var whirl : int = 0;
    public var blur : int = 0;
    
    public var pointillizeSize : int = 0;
    public var pointillizeForm : Image = null;
    
    public var waterRippleRate : int = 0;
    public var waterArray1 : * = null;
    public var waterArray2 : * = null;
    
    
    public function clearFilterCaches() : void {
        cachedForm = null;
        reapply = true;
    }
    
    /**
     * Do any of the filters need to be reapplied?
     * 
     * Was: 'filtersActive'
     */
    public function needToApplyFilters() : Boolean {
        if (reapply) return true;
        
        return (pointillizeSize != 0) || (waterRippleRate != 0);
    }
    
    //This maybe should be a BitmapImageData
    public function applyFiltersTo(image : Image) : Image {
        //No-Op
        return image;
    }
}
    
}