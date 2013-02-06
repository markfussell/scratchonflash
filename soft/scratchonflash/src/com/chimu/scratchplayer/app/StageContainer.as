package com.chimu.scratchplayer.app {
    import mx.containers.Canvas;
    

/**
 * The StageContainer provides the api to get into the graphics 
 * and other media of the system.
 * 
 */
public interface StageContainer {
    function getStageCanvas() : Canvas;

}

}