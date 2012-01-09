package moonaire.lune.core;

import moonaire.lune.Lune;
import moonaire.lune.util.HashTools;
import moonaire.orbit.Function;
import moonaire.orbit.structs.DList;
import moonaire.orbit.structs.DListIterator;

/**
 * ...
 * @author Munir Hussin
 */

class Entity implements Dynamic
{
    // base stuff
    public static var defs:Hash<Hash<Dynamic>> = new Hash<Hash<Dynamic>>();
    public static var count:Int = 0;
    public var lune:Lune;
    
    // static properties
    public var settings:Hash<Dynamic>;
    
    // TODO: internal properties
    //private var components:DList<Component>;
    //private var componentIterator:DListIterator<Component>;
    
    // base properties
    public var world:World;
    public var isActive:Bool;
    public var isDestroyed(default, null):Bool;
    public var hasDisposed(default, null):Bool;
    public var stateTime:Float;
    public var thinkTime:Float;
    
    // events
    public var onCreate:Dynamic;
    public var onDestroy:Dynamic;
    public var onUpdate:Dynamic;
    public var onState:Dynamic;
    public var onThink:Dynamic;
    
    
    public function new(world:World, name:String, ?init:Hash<Dynamic>)
    {
        //super();
        
        // base initialization
        this.world = world;
        this.lune = world.lune;
        
        // internal properties initialization
        //components = new DList<Entity>();
        //componentIterator = components.iterator();
        
        // defaults
        isActive = false;
        isDestroyed = false;
        hasDisposed = false;
        stateTime = 0;
        thinkTime = 0;
        
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
            settings = null;
            lune = null;
            world = null;
            count--;
        }
    }
    
    public function update(dt:Float, fdt:Float):Void
    {
        stateTime += dt;
        
        if (thinkTime > 0)
        {
            thinkTime -= dt;
            
            if (thinkTime <= 0)
            {
                // raise think event
                Function.apply(this, onThink, [dt, fdt], null);
            }
        }
        
        // raise update event
        Function.apply(this, onUpdate, [dt, fdt], null);
    }
}