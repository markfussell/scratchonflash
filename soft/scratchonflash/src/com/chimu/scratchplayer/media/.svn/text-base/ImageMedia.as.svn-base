package com.chimu.scratchplayer.media {
    import flash.display.BitmapData;
    import flash.geom.Point;
    
    

/**
 * ImageMedia is an Image
 */
public class ImageMedia extends ScratchMedia {
    public var form : BitmapData;
    public var rotationCenter : Point;
    
    
    
    public function initFieldsFrom_version(fieldList : Array, classVersion : Number) : void {
        // mediaName
        // form, rotationCenter, textBox, jpegBytes, compositeForm
        
        var i : int = 0;
        var init_mediaName      : * = fieldList[i++];
        var init_form           : * = fieldList[i++];
        var init_rotationCenter : * = fieldList[i++];
        var init_textBox        : * = fieldList[i++];
        var init_jpegBytes      : * = fieldList[i++];
        var init_compositeForm  : * = fieldList[i++];

        mediaName = init_mediaName;
        rotationCenter = init_rotationCenter;
        if (init_form != null) {
            var bitmap : BitmapData = (init_form as StForm).createBitmap();
            form = bitmap;
        }
    }
}
    
}