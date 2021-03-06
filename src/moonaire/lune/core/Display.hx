package moonaire.lune.core;

import moonaire.lune.Lune;
import nme.display.DisplayObject;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageDisplayState;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.Lib;

/**
 * The display's origin is in the center of the screen.
 * ALIGN_CENTER_SCALE_CROP is especially useful when designing
 * for multi-platform with different resolution. We design
 * for the highest aspect ratio (eg 16:9) and when viewed with
 * a lower one (4:3), the edges will be cropped off.
 * 
 * Avoid using absolute coordinates, and instead use relative
 * coordinates when you want to place something relative to
 * the screen.
 * 
 * @author Munir Hussin
 */

class Display
{
    public static inline var ALIGN_CENTER_SCALE_CROP = 0;
    public static inline var ALIGN_CENTER_SCALE_NOCROP = 1;
    public static inline var ALIGN_CENTER_NOSCALE = 2;
    
    public var lune:Lune;
    public var stage:Stage;
    public var view:Sprite;
    public var debug:Sprite;
    
    public var scaleMode:Int;
    
    public var realWidth:Int;
    public var realHeight:Int;
    public var realCenterX:Float;
    public var realCenterY:Float;
    
    public var virtualWidth:Float;
    public var virtualHeight:Float;
    
    
    public function new(lune:Lune) 
    {
        this.lune = lune;
        
        view = new Sprite();
        debug = new Sprite();
        
        Lib.current.addChild(view);
        Lib.current.addChild(debug);
        
        scaleMode = ALIGN_CENTER_SCALE_CROP;
        
        stage = Lib.current.stage;
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.addEventListener(Event.RESIZE, stage_onResize);
        
        realWidth = stage.stageWidth;
        realHeight = stage.stageHeight;
        realCenterX = realWidth / 2;
        realCenterY = realHeight / 2;
        
        // virtualHeight is a constant fixed to 720 (highest resolution)
        virtualHeight = 720;
        virtualWidth = virtualHeight * realWidth / realHeight;
        
        stage_onResize(null);
    }
    
    
    public function realToVirtualX(realX:Float):Float
    {
        return virtualWidth * realX / realWidth;
    }
    
    public function realToVirtualY(realY:Float):Float
    {
        return virtualHeight * realY / realHeight;
    }
    
    public function virtualToRealX(virtualX:Float):Float
    {
        return realWidth * virtualX / virtualWidth;
    }
    
    public function virtualToRealY(virtualY:Float):Float
    {
        return realHeight * virtualY / virtualWidth;
    }
    
    
    public function _debug():Void
    {
        // draw a colored rectangle the size of the target resolution,
        // a rectangle in the middle of that, and another rectangle
        // somewhere else. helps to visualize display scaling
        
        var gfx:Graphics = view.graphics;
        
        gfx.beginFill(0xFF0000, 0.4);
            gfx.drawRect(-realCenterX, -realCenterY, realWidth, realHeight);
        gfx.endFill();
        
        gfx.beginFill(0x00FF00, 0.4);
            gfx.drawRect(-10, -10, 20, 20);
        gfx.endFill();
        
        
        var sub:Sprite = new Sprite();
        gfx = sub.graphics;
        
        gfx.beginFill(0xFFFF00, 0.4);
            gfx.drawRect(10, 50, 300, 300);
        gfx.endFill();
        
        view.addChild(sub);
    }
    
    
    public function toggleFullScreen():Void
    {
        #if nme
            var stage:Stage = Lib.current.stage;
            stage.displayState = Type.enumEq(stage.displayState, StageDisplayState.NORMAL) ?
                StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
        #end
    }
    
    
    public inline function getFitScale(containerWidth:Float, containerHeight:Float, childWidth:Float, childHeight:Float):Float
    {
        return Math.min(containerWidth / childWidth, containerHeight / childHeight);
    }
    
    public inline function getFillScale(containerWidth:Float, containerHeight:Float, childWidth:Float, childHeight:Float):Float
    {
        return Math.max(containerWidth / childWidth, containerHeight / childHeight);
    }
    
    public inline function alignCenterScaleCrop():Void
    {
        var scale:Float = getFillScale(stage.stageWidth, stage.stageHeight, realWidth, realHeight);
        view.scaleX = scale;
        view.scaleY = scale;
        debug.scaleX = scale;
        debug.scaleY = scale;
        alignCenterNoScale();
    }
    
    public inline function alignCenterScaleNoCrop():Void
    {
        var scale:Float = getFitScale(stage.stageWidth, stage.stageHeight, realWidth, realHeight);
        view.scaleX = scale;
        view.scaleY = scale;
        debug.scaleX = scale;
        debug.scaleY = scale;
        alignCenterNoScale();
    }
    
    public inline function alignCenterNoScale():Void
    {
        view.x = stage.stageWidth / 2;
        view.y = stage.stageHeight / 2;
    }
    
    private function stage_onResize(event:Event):Void
    {
        switch (scaleMode)
        {
            case ALIGN_CENTER_NOSCALE: alignCenterNoScale();
            case ALIGN_CENTER_SCALE_CROP: alignCenterScaleCrop();
            case ALIGN_CENTER_SCALE_NOCROP: alignCenterScaleNoCrop();
        }
        
    }
}