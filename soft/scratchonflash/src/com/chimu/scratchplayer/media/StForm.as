package com.chimu.scratchplayer.media {
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    
    

/**
 * An StForm is a Smalltalk form object.
 * This is only used to deal with serialization
 * conversion aspects... 
 */
public class StForm {
    public var width : int;
    public var height : int;
    public var depth : int;
    public var offset : int;
    public var bits : *;  //Can initially be an ObjRefRecord
    public var privateColor : *;  //Can initially be an ObjRefRecord
    
    public function createBitmap() : BitmapData {
        var result : BitmapData = new BitmapData(width,height);
        
        var byteArray : ByteArray = bits as ByteArray;
        
        byteArray.position = 0;
        var length : int = readDecodedInt(byteArray);
        var outArray : ByteArray = new ByteArray();
        outArray.length = length*4;
        outArray.position = 0;

        var i : int = 0; //Read index
        var k : int = 0;
        
        while ( (k < length) && (byteArray.bytesAvailable > 0) ) {
            var word : int = readDecodedInt(byteArray);
            var runLength : int = word >> 2;
            var dataCode : int = word & 0x03;
            switch (dataCode) {
                case 0: break;
                case 1: putNextByteOf_into_times(byteArray,outArray,runLength); break;
                case 2: putNextIntOf_into_times(byteArray,outArray,runLength); break;
                case 3: putIntsFrom_into_times(byteArray,outArray,runLength); break
            }
            k += runLength;
        }

        //MLF: We might be able to do both of these together -- pixels and decompression
        //var testHeight : Number = Math.min(height, Math.floor(outArray.length / width / 4));

        var rect : Rectangle = new Rectangle(0,0,width,height);
        outArray.position = 0;
        if (depth == 32) {
            result.setPixels(rect,outArray);
        } else if (depth < 8) {
            //Walk the bytes and write the pixels :-(
            writePixelsFrom_to_rect_depth_colorTable(outArray, result, rect, depth, privateColor);
        } else {
            //
        }
        
        return result;
    }

    //From: Color::initializeIndexedColors
    static protected const CONST_defaultColorTable : Array = [
        {rgb: 0xFFFFFF, alpha: null},
        {rgb: 0x000000, alpha: null},
        {rgb: 0xFFFFFF, alpha: null},
        {rgb: 0x808080, alpha: null},
        ];

    protected function writePixelsFrom_to_rect_depth_colorTable(outArray : ByteArray , bitmap : BitmapData, rect : Rectangle, depth : int, colorTable: Array) : void {
        var x:int = 0;
        var y:int = 0;
        var width:int = rect.width;
        var shifts:int = Math.floor(8 / depth);
        var mask:int = (0x01 << depth) - 1;

        var partial : int = (width % shifts);
        if (partial != 0) width += (shifts - partial); 

        if (colorTable == null) {
            colorTable = CONST_defaultColorTable;
        } else {
            colorTable = fixColorTable(colorTable);
        }
        
        while (outArray.bytesAvailable>0) {
            var nextByte : int = outArray.readByte();
            for (var shiftIndex:int = 0; shiftIndex<shifts; shiftIndex++) {
                var index : int = nextByte & mask;
                var color : * = colorTable[index];
                var rgb : int = color.rgb;
                var alpha : * = color.alpha;

                if (alpha != null) {
                    rgb = alpha << 24 + rgb;
                    bitmap.setPixel32(x + (shifts - shiftIndex - 1), y, rgb);
                } else {
                    bitmap.setPixel(x + (shifts - shiftIndex - 1), y, rgb);
                }
                nextByte = nextByte >> depth;
            }
            x += shifts;
            if (x >= width) {
                x=0;
                y++;
            }
        }
        if (outArray.bytesAvailable > 0) {
            trace("Had extra bytes: "+outArray.bytesAvailable);
        }
    }

    //There are too many bits in the Smalltalk colors, so we need to strip some of them:
    protected function fixColorTable(colorTable : Array) : Array {
        var result : Array = new Array();
        for each (var entry:* in colorTable) {
            var eachRgb : int= entry.rgb;
            var outRgb : int =  ( ( (eachRgb >> 22) & 0xff) << 16) + ( ( (eachRgb >> 12) & 0xff ) << 8 ) + ( ( (eachRgb >> 2) & 0xff ) );
            result.push( {rgb:outRgb, alpha:entry.alpha} );
        }
        return result;
        
    }
    
    protected function putNextByteOf_into_times(byteArray : ByteArray, outArray : ByteArray, runLength : int) : void {
        var data : int = byteArray.readUnsignedByte();
        var fullData : int = data << 24 | data << 16 | data << 8 | data;
        for (var i:int=0; i<runLength; i++) {
            outArray.writeUnsignedInt(fullData);
        }
    }
    
    protected function putNextIntOf_into_times(byteArray : ByteArray, outArray : ByteArray, runLength : int) : void {
        var data : int = byteArray.readUnsignedInt();
        for (var i:int=0; i<runLength; i++) {
            outArray.writeUnsignedInt(data);
        }
    }
    
    
    protected function putIntsFrom_into_times(byteArray : ByteArray, outArray : ByteArray, runLength : int) : void {
        for (var i:int=0; i<runLength; i++) {
            var data : int = byteArray.readUnsignedInt();
            outArray.writeUnsignedInt(data);
        }
    }
    
    
    protected function readDecodedInt(byteArray : ByteArray) : int {
        var first : int = byteArray.readUnsignedByte();
        if (first < 224) {
            return first;
        } else if (first < 255) {
            var result : int = byteArray.readUnsignedByte();
            result += (first - 224) * 256;
            return result;
        } else {
            return byteArray.readUnsignedInt();
        }
    } 
}
    
}