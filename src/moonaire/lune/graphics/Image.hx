package moonaire.lune.graphics;

import moonaire.lune.core.Layer;
import moonaire.lune.Lune;
import moonaire.lune.util.HashTools;
import moonaire.orbit.Function;
import moonaire.orbit.structs.DList;
import moonaire.orbit.structs.DListIterator;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.PixelSnapping;
import nme.display.Sprite;

/**
 * ...
 * @author Munir Hussin
 */

class Image extends Sprite, implements Dynamic
{
    // constants
    public static var PIXELSNAP_ALWAYS:Int = 0;
    public static var PIXELSNAP_AUTO:Int = 1;
    public static var PIXELSNAP_NEVER:Int = 2;
    
    // base stuff
    public static var defs:Hash<Hash<Dynamic>> = new Hash<Hash<Dynamic>>();
    public static var count:Int = 0;
    public var lune:Lune;
    
    // static properties
    public var settings:Hash<Dynamic>;
    
    // internal properties
    public var bitmap:Bitmap;
    
    // base properties
    public var layer:Layer;
    public var isActive:Bool;
    public var isDestroyed(default, null):Bool;
    public var hasDisposed(default, null):Bool;
    
    public var virtualWidth:Float;
    public var virtualHeight:Float;
    public var originX:Float;
    public var originY:Float;
    
    
    // events
    public var onCreate:Dynamic;
    public var onDestroy:Dynamic;
    
    
    public function new(layer:Layer, name:String, ?init:Hash<Dynamic>)
    {
        super();
        
        // base initialization
        this.layer = layer;
        this.lune = layer.lune;
        
        // internal properties initialization
        
        // defaults
        isActive = false;
        isDestroyed = false;
        hasDisposed = false;
        
        // instance initialization
        var def:Hash<Dynamic> = defs.get(name);
        
        if (def != null)
        {
            HashTools.copyIntoObject(def.get("properties"), this);
            HashTools.copyIntoObject(init, this);
            settings = def.get("settings");
            
            if (settings != null)
            {
                var bmpFile:String = settings.get("bitmap");
                
                if (bmpFile != null)
                {
                    var bitmapData:BitmapData = lune.resource.loadImage(bmpFile);
                    
                    if (bitmapData != null)
                    {
                        bitmap = new Bitmap(bitmapData);
                        addChild(bitmap);
                        
                        var smoothing:Bool = settings.get("smoothing");
                        bitmap.smoothing = smoothing;
                        
                        var pixelSnapping:Int = settings.get("pixelSnapping");
                        
                        if (pixelSnapping == PIXELSNAP_ALWAYS)
                        {
                            bitmap.pixelSnapping = PixelSnapping.ALWAYS;
                        }
                        else if (pixelSnapping == PIXELSNAP_AUTO)
                        {
                            bitmap.pixelSnapping = PixelSnapping.AUTO;
                        }
                        else if (pixelSnapping == PIXELSNAP_NEVER)
                        {
                            bitmap.pixelSnapping = PixelSnapping.NEVER;
                        }
                    }
                }
            }
        }
        
        if (bitmap != null)
        {
            bitmap.x = -originX;
            bitmap.y = -originY;
            bitmap.width = virtualWidth;
            bitmap.height = virtualHeight;
        }
        
        if (layer != null)
        {
            layer.addChild(this);
        }
        
        // keep count
        count++;
        create();
    }
    
    
    public static function define(name:String, data:Hash<Dynamic>):Void
    {
        defs.set(name, data);
    }
    
    public function create():Void
    {
        // raise create event
        Function.apply(this, onCreate, [], null);
    }
    
    /// mark the object to be destroyed
    public function destroy():Void
    {
        isDestroyed = true;
        dispose();
    }
    
    /// dispose the object (unallocate whatever)
    public function dispose():Void
    {
        // prevent multiple triggers
        if (!hasDisposed)
        {
            hasDisposed = true;
            
            //  raise destroy event
            Function.apply(this, onDestroy, [], null);
            
            // cleanup
            if (parent != null) parent.removeChild(this);
            removeChild(bitmap);
            bitmap = null;
            
            settings = null;
            lune = null;
            layer = null;
            count--;
        }
    }
}