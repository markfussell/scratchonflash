package com.chimu.scratchplayer.objectio {
    

/**
 * An ObjRefRecord stores a pointer to the
 * actual object record.
 */
public class ObjRefRecord {
    public var stream : ObjStream;
    public var objectId : Number;
    
    public function initStream_objectId(aStream : ObjStream, id:Number) : ObjRefRecord {
        aStream = stream;
        objectId = id;
        
        return this;
    }
    
    public function getValue() : * {
        if (stream == null) return null;
        if (stream.objects == null) return null;
        var entry : * = stream.objects[objectId-1];
        if (entry == null) return null;
        return entry.obj;
    }
    public function toString() : String {
        return "<Ref id="+objectId+" value="+getValue()+">";
    }
}
    
}