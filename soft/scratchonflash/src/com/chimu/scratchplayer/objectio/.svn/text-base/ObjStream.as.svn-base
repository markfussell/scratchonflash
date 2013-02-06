package com.chimu.scratchplayer.objectio {
    import com.chimu.scratchplayer.app.ScratchApp;
    import com.chimu.scratchplayer.media.ImageMedia;
    import com.chimu.scratchplayer.media.StForm;
    import com.chimu.scratchplayer.objects.SpriteMorph;
    import com.chimu.scratchplayer.objects.StageMorph;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
/**
 * ObjStream can deserialize a collection (a project) of Scratch objects.
 * 
 * See the 1.2 Scratch documentation for more information.
 * 
 * Because a Scratch Player does not care about all the objects in the
 * original projects, it may discard some of them during the resolution 
 * phase... at which point they are replaced by 'null'.  But all objects
 * have to actually be tokenized properly or the reader will be off by bytes.
 * 
 * Note that I believe the 1.3 format has a new 'header' and 'body' format
 * as well as a few new types.  These were created ad-hoc (reverse engineered)
 * so they may have issues.
 */  
public class ObjStream {
    public var objects : Array;
    protected var objectIndex : int;
    protected var stream : ByteArray;
    protected var firstPass : Boolean;

    protected var fields : *;
    protected var fieldIndex : *;
    protected var toDo : *; 
    

    static protected var shared_outerApp : ScratchApp;
    static protected function logInfo(info : String) : void {
        shared_outerApp.logInfo(info);
    }
    
    //==========================================================
    //==========================================================
    //==========================================================
    
    static public function initializeFor(app : ScratchApp) : void {
        shared_outerApp = app;
        
        shared_IdToClassEntryMap = new Dictionary();
        
        //var sample : ObjStream = new ObjStream();
        
        var i : int = 1;
        //MLF: Decided not to do it this way... but see how Blocks work for the right idiom
        //shared_IdToClassEntryMap[i++] = {id: i, entryClass: null,    readSelector: "getConst:id:", readFunction: sample.getConst_id, writeSelector: "putConst:id:", writeFunction: null};

        //MLF: Only use this mapping for the custom classes...
        i = 100;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "Morph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "BorderedMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "RectangleMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "EllipseMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "AlignmentMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "StringMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "UpdatingStringMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "SimpleSliderMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "SimpleButtonMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "SampleSound"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ImageMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "SketchMorph"}; i++;
        
        i=120;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "SpriteMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "SoundMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ImageBoxMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "SensorBoardMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: SpriteMorph}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: StageMorph}; i++;
       
        i=140;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ChoiceArgMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ColorArgMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ExpressionArgMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ParameterReferenceMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "PositionArgMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "SpriteArgMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "VariableArgMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "BlockMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "CommandBlockMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "x-CBlock"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "MethodCallBlockMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "x-HatBlock"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ScratchButtonMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ScratchScriptsMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ScratchSliderMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "WatcherMorph"}; i++;

        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ParameterMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "x-SetterBlock"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "x-EventHatBlock"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "EventArgMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "x-VariableBlock"}; i++;
        
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "IACTHatMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: ImageMedia}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "MovieMedia"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "SoundMedia"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "KeyEventHatMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "BooleanArgMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "EventTitleMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "MouseClickEventHatMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ExpressionArgMorphWithMenu"}; i++;
         
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ReporterBlockMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "MultilineStringMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "ToggleButton"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "WatcherReadoutFrameMorph"}; i++;
        shared_IdToClassEntryMap[i] = {id: i, entryClass: "WatcherSliderMorph"}; i++;
        
        //ListWatcherMorph
    }

    //==========================================================
    //==========================================================
    //==========================================================
    
    public function readStageFrom_showProgress(s : ByteArray, showProgress : Boolean) : StageMorph {
        objects = new Array();
        stream = s;
        readFileHeader();
        
        //===========================
        //=== The MetaData Section
        //===========================
        
        readObjectSection();
        
        //===========================
        //=== The Main Section
        //===========================
        
        readObjectSection();
        
        return objects[0].obj;
    }
    
    protected function readObjectSection() : * {
        readObjSStchHeader();
        
        firstPass = true;
        objects = new Array();
        
        var objCount2:int = stream.readUnsignedInt();//getUint32();
        my_maxObject = objCount2;
        logInfo("Creating "+objCount2+" objects");
        
        for (var i2:int=0; i2<objCount2; i2++) {
            objects.push(readObjectRecord());
            //logInfo("Created Object #"+(i2+1));
        }
        
        //MLF: This is a hack to let things use the same methods twice?
        firstPass = false;
        for each (var rec1 : * in objects) {
            fixReferencesForObjectRecord(rec1);
        }
        for each (var rec2 : * in objects) {
            initializeUserDefinedFields(rec2);
        }
        
        return objects[0].obj;
    }
    
    static protected const CONST_FirstPointerClassId : int = 20;
    static protected const CONST_FirstUserClassId : int = 100;
    
    protected function fixReferencesForObjectRecord(record : *) : void {
        if (record == null) return;
        
        var classId : int = record.classId;
        if (classId < CONST_FirstPointerClassId) return;

        //Second pass conversion
        if (classId < CONST_FirstUserClassId) {
            record.obj = doGet_forClass(record.obj, classId);
        } else {
            fixRefsInArray(record.fieldList);
        }
    }
    
    protected function fixRefsInArray(anArray : Array) : void {
        for (var i:int = 0 ; i<anArray.length; i++) {
            var el : * = anArray[i];
            if (el is ObjRefRecord) {
                anArray[i] = getObjectFromReference(el);
            }
        }
    }
    
    protected function getObjectFromReference(ref : ObjRefRecord) : * {
        if (ref == null) return null;
        
        var entry : * = objects[ref.objectId-1];
        if (entry == null) return null;
        var result : * = entry.obj;
        if (result is ObjRefRecord) {
            return getObjectFromReference(ref);
        } else {
            return result;
        }
    }
    
    
    protected function initializeUserDefinedFields(record : *) : void {
        if (record == null) return;
        var classId : int = record.classId;
        if (classId < CONST_FirstUserClassId) {
            return;
        }
        
        var obj : * = record.obj;
        var classVersion : * = record.classVersion;
        var fieldList : Array = record.fieldList;
        
        obj.initFieldsFrom_version(fieldList,classVersion); 
    }

    protected function readFileHeader() : void {
        var okHeader : Boolean = true;

        var testString : String = stream.readUTFBytes(10);
        okHeader &&= ( testString.match("^ScratchV\\d\\d") != null );
        //header=ScratchV##
        
        var spacer : int = stream.readInt();
    }

    protected function readObjSStchHeader() : void {
        var okHeader : Boolean = true;

        okHeader &&= (stream.readUTFBytes(4) == "ObjS");
        okHeader &&= stream.readByte() == 1;
        okHeader &&= (stream.readUTFBytes(4) == "Stch");
        okHeader &&= stream.readByte() == 1;
    }
    
    protected function readObjectRecord() : * {
        var classId : int = stream.readUnsignedByte();
        
        if (classId > CONST_ObjectReferenceID) {
            var classVersion : int = stream.readUnsignedByte();
            var fieldCount : int = stream.readUnsignedByte();
            var fieldList : Array = new Array(fieldCount);
            for (var i:int = 0; i<fieldCount; i++) {
                fieldList[i] = readField();
            }

            //logInfo("Creating user class: "+classId);
                
            var entry : * = shared_IdToClassEntryMap[classId];
            if (entry == null) {
                logInfo("No user class found for: "+classId);
                return null;
            }
            
            var userClass_obj : * = entry.entryClass;
            if (userClass_obj is String) {
                logInfo("Stubbed user class "+userClass_obj+" found for: "+classId);
                return null;
            }
            var userClass : Class = (userClass_obj as Class);
            var resultObject : * = new userClass;
            
            logInfo("User class: "+classId+" created: "+resultObject);
            
            return {obj: resultObject, classId: classId, classVersion: classVersion, fieldList: fieldList};
        } else {
            /*
            var entry : * = shared_IdToClassEntryMap[classId];
            var readSelector : String = shared_IdToClassEntryMap[classId].selector;
            var readFunction : Function = shared_IdToClassEntryMap[classId].selFunction;
            */
            
            resultObject = doGet_forClass(null, classId);

            if (resultObject == null) {
                logInfo("Missing class: "+classId);
                return null;
            } else {
                //logInfo("Found class: "+classId);
                //logInfo("Produced: "+resultObject);
            }
            
            
            //var resultObject : * = readFunction.call(this, null, classId);
            return {obj: resultObject, classId: classId, classVersion: null, fieldList: null};
        }
    }

    protected function doGet_forClass(anObject : * , classId : int) : * {
        switch (classId) {
            case 1: return getConst_id(anObject,classId);
            case 2: return getConst_id(anObject,classId);
            case 3: return getConst_id(anObject,classId);

            case 4: return getSmallInt_id(anObject,classId);
            case 5: return getSmallInt_id(anObject,classId);

            case 8: return getDouble_id(anObject,classId);
            case 9: return getBytes_id(anObject,classId);
            case 10: return getBytes_id(anObject,classId);
            case 11: return getBytes_id(anObject,classId);
            case 12: return getSoundBuffer_id(anObject,classId);
            case 13: return getBitmap_id(anObject, classId);
            case 14: return getBytes_id(anObject,classId);
            //15-19 reserved
            
            case 20: return getArray_id(anObject,classId);
            case 21: return getArray_id(anObject,classId);
            case 22: return getArray_id(anObject,classId);
            case 23: return getArray_id(anObject,classId);

            case 24: return getDict_id(anObject,classId);
            case 25: return getDict_id(anObject,classId);
            //26-29 reserved
            
            case 30: return getColor_id(anObject,classId);
            case 31: return getColor_id(anObject,classId);
            case 32: return getPoint_id(anObject,classId);
            case 33: return getRect_id(anObject,classId);
            case 34: return getForm_id(anObject,classId);
            case CONST_ClassId_ColorForm: return getForm_id(anObject,classId);
        }

        return null;
    }
    

    static protected const CONST_ClassId_String : int = 9;
    static protected const CONST_ClassId_Symbol : int = 10;
    static protected const CONST_ClassId_ColorForm : int = 35;
    static protected const CONST_ClassId_TranslucentColor : int = 31;
    
    
    //===============================================================
    //=== Fixed format-readying
    //===============================================================
    
    public function getArray_id(anObject : *, classId: int) : * {
        if (!firstPass) {
            fixRefsInArray(anObject as Array);
            return anObject;
        }
        
        
        var size : int = stream.readUnsignedInt();
        var result : Array = new Array ();
        for (var i:int = 0; i<size; i++) {
            var value : * = readField();
            result.push(value);
        }
        return result;
    }

    public function getBitmap_id(anObject : *, classId: int) : * {
        if (!firstPass) return anObject;
        
        var count : int = stream.readUnsignedInt();
        var result : ByteArray = new ByteArray();
        for (var i:int = 0; i<count; i++) {
           result.writeUnsignedInt(stream.readUnsignedInt());
        }
        return result;
    }
    
    
    public function getBytes_id(anObject : *, classId: int) : * {
        if (!firstPass) return anObject;
        
        var count : int = stream.readUnsignedInt();
        //stream.readBytes(
        var result : ByteArray = new ByteArray();
        if (classId == 14) {
            return stream.readUTFBytes(count);
        } else {
            for (var i:int = 0; i<count; i++) {
               result.writeByte(stream.readByte());
            }
            if (classId == CONST_ClassId_String) {
                return new String(result);
            }
            if (classId == CONST_ClassId_Symbol) {
                return new String(result);
            }
            return result;
        }
    }
    
    
    public function getColor_id(anObject : *, classId: int) : * {
        if (!firstPass) return anObject;

        var rgb : int = stream.readUnsignedInt();
        //logInfo("ClassId = "+classId+" RGB = "+rgb);
        if (classId == CONST_ClassId_TranslucentColor) {
            var alpha : int = stream.readUnsignedByte();
            return {rgb: rgb, alpha: alpha};
        } else {
            return {rgb: rgb, alpha: null};
        }
    }

    
    
    
    
    public function getConst_id(anObject : *, classId: int) : * {
        if (!firstPass) return anObject;
        
        if (classId == 1) return null;
        if (classId == 2) return true;
        if (classId == 3) return false;
    }
    
    
    public function getDict_id(anObject : *, classId: int) : * {
        if (firstPass) {
            var size : int = stream.readUnsignedInt();
            var result : Dictionary = new Dictionary();
            for (var i:int = 0; i<size; i++) {
                var key : * = readField();
                var value : * = readField();
                result[key]=value;
            }
            return result;
        } else {
            //var newResult : Dictionary = new Dictionary();
            var keys : Array = new Array();
            
            //Clone to a new array
            for (var key1 : * in (anObject as Dictionary)) {
                keys.push(key1);
            }
            
            
            for each (var key2: * in keys) {
                var newKey : * = key2;
                if (newKey is ObjRefRecord) {
                    newKey = getObjectFromReference(newKey as ObjRefRecord);
                }
                var newValue : * = anObject[key2];
                if (newValue is ObjRefRecord) {
                    newValue = getObjectFromReference(newValue as ObjRefRecord);
                }
                
                //Swap the old an the new keys
                delete anObject[key2];
                anObject[newKey] = newValue;
            }
            //Fix all the targetObjectRefs
        }
    }

    public function getDouble_id(anObject : *, classId: int) : * {
        if (!firstPass) {return anObject;};
        
        var result : Number = stream.readDouble();
        
        return result;
    }

    public function getForm_id(anObject : *, classId: int) : * {
        if (!firstPass) {
            anObject.bits = getObjectFromReference(anObject.bits);
            //anObject.offset = getObjectFromReference(anObject.offset);
            anObject.privateColor = getObjectFromReference(anObject.privateColor);

            return anObject;
        }
        
        var w : * = readField();
        var h : * = readField();
        var d : * = readField();
        var offset : * = readField();
        var bits : * = readField();
        var privateColor : * = null;

        if (classId == CONST_ClassId_ColorForm) {
            privateColor = readField();
        }
        
            
        var result : StForm = new StForm();
        result.bits = bits;
        result.width = w;
        result.height = h;
        result.depth = d;
        result.offset = offset;
        result.privateColor = privateColor;

        return result;
            
    }
    

    public function getPoint_id(anObject : *, classId: int) : * {
        if (!firstPass) {
            //deference targets
            return anObject;
        }
        
        var x1 : * = readField();
        var y1 : * = readField();
        
        return new Point(x1,y1);
    }

    
    
    public function getRect_id(anObject : *, classId: int) : * {
        if (!firstPass) {
            //deference targets
            return anObject;
        }
        
        var x1 : * = readField();
        var y1 : * = readField();
        var x2 : * = readField();
        var y2 : * = readField();
        
        return new Rectangle(x1, y1, x2-x1, y2-y1);
    }

    
    public function getSoundBuffer_id(anObject : *, classId: int) : * {
        if (!firstPass) {
            //deference targets
            return anObject;
        }
        
        var sampleCount : int = stream.readUnsignedInt();
        var result : Array = new Array(sampleCount);
        for (var i:int=0; i<sampleCount; i++) {
            result.push(stream.readUnsignedShort());
        }
        
        return result;
    }

    
    
    public function getSmallInt_id(anObject : *, classId: int) : * {
        if (!firstPass) return anObject;
        
        if (classId == 4) return stream.readInt();
        if (classId == 5) return stream.readShort();
    }
    
    
    //===============================================================
    //===============================================================
    //===============================================================

    protected function targetObjectFor(anObject : *) : * {
        if (anObject is ObjRefRecord) {
            return objects[(anObject as ObjRefRecord).objectId].obj
        } else {
            return anObject;
        }
    }
    
    
    
    static protected var shared_IdToClassEntryMap : Dictionary = null;
    static protected const CONST_ObjectReferenceID : Number = 99;
    
    protected var my_maxObject : Number = 0;
    protected function createObjRefRecord_ForId(id : Number) : ObjRefRecord {
        //logInfo("readField::ReferenceTo: #"+id);
        if ( (my_maxObject > 0) && (id > my_maxObject) ) {
            logInfo("readField::OutOfBoundReference: #"+id);
        }
        return new ObjRefRecord().initStream_objectId(this, id);
    }
    
    protected function readField() : * {
        var classId : int = stream.readUnsignedByte();
        
        if (classId == CONST_ObjectReferenceID) {
            var id : int = stream.readUnsignedByte();
            id = (id << 8) + stream.readUnsignedByte();
            id = (id << 8) + stream.readUnsignedByte();
            
            return createObjRefRecord_ForId(id);
        } else {
            var resultObject : * = doGet_forClass(null,classId);
            if (resultObject == null) {
                if (classId != 1) {
                    logInfo("readField::Missing class: "+classId);
                    return null;
                }
                return null;
            } else {
                //logInfo("readField::Found class: "+classId);
                //logInfo("readField::Produced: "+resultObject);
            }
            
            
            return resultObject;
        }
    }
    
}
    
}