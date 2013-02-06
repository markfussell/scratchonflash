package com.chimu.scratchplayer.translation {
    import flash.utils.Dictionary;
    
    

/**
 * A collection of completely static function.
 * Currently I am not supporting translation, but
 * need this because the 'var' translator is 
 * required for getting proper number of 
 * actual arguments.
 * 
 * Was: ScratchTranslator [without the Lib]
 */
public class ScratchTranslatorLib     {
    static protected const CONST_variablePlaceholder : String = "%v";
    static public function varSpecTranslationFor_varName(spec : String, varName : String) : String {
        return spec.replace(CONST_variablePlaceholder, varName);
    }
    
    
    
    static protected const CONST_charNameToCharacterCodeMap : Object = {backspace: 8, cr: 13, enter:3, lf: 10, linefeed:10, newPage:12, space:32, tab:9};
    static public function characterFromStCharName(charName : String) : String {
        if (!CONST_charNameToCharacterCodeMap.hasOwnProperty(charName)) return charName;
        
        return String.fromCharCode(CONST_charNameToCharacterCodeMap[charName]);
    }

    static protected const CONST_keyCodeToLongName : Object = {37: "left arrow", 38: "up arrow", 39: "right arrow", 40: "down arrow"};
    static public function longNameFromKeyCode(keyCode : int) : String {
        if (!CONST_keyCodeToLongName.hasOwnProperty(keyCode)) return ""+int;
        
        return CONST_keyCodeToLongName[keyCode];
    }

    
//, "left arrow": 37, "up arrow":38, "right arrow":39, "down arrow":40    
    //static protected const CONST_charNameToCharacterCodeMap
}

}