package moonaire.lune.core;

import moonaire.lune.Lune;
import moonaire.lune.util.HashTools;
import moonaire.orbit.Function;
import moonaire.orbit.structs.DList;
import moonaire.orbit.structs.DListIterator;
import nme.display.Sprite;

/**
 * ...
 * @author Munir Hussin
 */

class Layer extends Sprite, implements Dynamic
{
    // base stuff
    public static var defs:Hash<Hash<Dynamic>> = new Hash<Hash<Dynamic>>();
    public static var count:Int = 0;
    public var lune:Lune;
    
    // static properties
    public var settings:Hash<Dynamic>;
    
    // internal properties
    
    // base properties
    public var world:World;
    public var isActive:Bool;
    public var isDestroyed(default, null):Bool;
    public var hasDisposed(default, null):Bool;
    public var isFixed:Bool;
    
    // events
    public var onCreate:Dynamic;
    public var onDestroy:Dynamic;
    public var onUpdate:Dynamic;
    public var onSort:Dynamic;
    
    
    public function new(world:World, name:String, ?init:Hash<Dynamic>)
    {
        super();
        
        // base initialization
        this.world = world;
        this.lune = world.lune;
        
        // internal properties initialization
        world.addChild(this);
        
        // defaults
        isActive = false;
        isDestroyed = false;
        hasDisposed = false;
        isFixed = false;
        
        // instance initialization
        var def:Hash<Dynamic> = defs.get(name);
        
        if (def != null)
        {
            HashTools.copyIntoObject(def.get("properties"), this);
            HashTools.copyIntoObject(init, this);
            settings = def.get("settings");
        }
        
        // keep count
        count++;
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
            
            settings = null;
            lune = null;
            world = null;
            count--;
        }
    }
    
    public function update(dt:Float, fdt:Float):Void
    {
        // raise update event
        Function.apply(this, onUpdate, [dt, fdt], null);
    }
    
    public function doSort():Void
    {
        // TODO: sort the children by a particular property
    }
}