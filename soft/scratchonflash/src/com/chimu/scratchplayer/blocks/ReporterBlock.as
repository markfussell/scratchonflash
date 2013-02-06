package com.chimu.scratchplayer.blocks {

/**
 * A ReporterBlock produces a value.  Currently either a numeric or boolean value (I believe).
 * 
 * Note that 'ArgMorph's are also Reporters.  May pull out the Reporter interface at some point
 */
public class ReporterBlock extends CommandBlock {
    public var isBoolean : Boolean;
    
}

}