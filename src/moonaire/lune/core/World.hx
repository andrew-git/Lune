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

class World extends Sprite, implements Dynamic
{
    // base stuff
    public static var defs:Hash<Hash<Dynamic>> = new Hash<Hash<Dynamic>>();
    public static var count:Int = 0;
    public var lune:Lune;
    
    // static properties
    public var settings:Hash<Dynamic>;
    
    // internal properties
    private var entities:DList<Entity>;
    private var entityIterator:DListIterator<Entity>;
    private var layers:DList<Layer>;
    private var layerIterator:DListIterator<Layer>;
    
    // base properties
    public var isActive:Bool;
    public var isDestroyed(default, null):Bool;
    public var hasDisposed(default, null):Bool;
    
    // events
    public var onCreate:Dynamic;
    public var onDestroy:Dynamic;
    public var onUpdate:Dynamic;
    
    
    public function new(lune:Lune, name:String, ?init:Hash<Dynamic>) 
    {
        super();
        
        // base initialization
        this.lune = lune;
        
        // internal properties initialization
        entities = new DList<Entity>();
        entityIterator = entities.iterator();
        layers = new DList<Layer>();
        layerIterator = layers.iterator();
        
        lune.display.view.addChild(this);
        
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
                var layerList:Array<Dynamic> = settings.get("layers");
                
                // instantiate layers
                HashTools.copyPairsIntoObject(layerList, this, function (key:String, value:Dynamic)
                {
                    if (Std.is(value, String))
                    {
                        return new Layer(this, value);
                    }
                    
                    return null;
                });
            }
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
        // initialize layers
        
        // initialize camera
        
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
            count--;
        }
    }
    
    public function update(dt:Float, fdt:Float):Void
    {
        // raise update event
        Function.apply(this, onUpdate, [dt, fdt], null);
        
        // update entities
        var entity:Entity;
        entityIterator.first();
        
        while (entityIterator.hasNext())
        {
            entity = entityIterator.peek();
            
            if (entity.isActive && !entity.isDestroyed)
                entity.update(dt, fdt);
                
            if (entity.isDestroyed)
            {
                entity.dispose();
                entityIterator.remove();
            }
            
            entityIterator.next();
        }
        
        // update layers
        var layer:Layer;
        layerIterator.first();
        
        while (layerIterator.hasNext())
        {
            layer = layerIterator.peek();
            
            if (layer.isActive && !layer.isDestroyed)
                layer.update(dt, fdt);
                
            if (layer.isDestroyed)
            {
                layer.dispose();
                layerIterator.remove();
                removeChild(layer);
            }
            
            layerIterator.next();
        }
    }
    
    public function createEntity(name:String, ?init:Hash<Dynamic>):Entity
    {
        var entity:Entity = new Entity(this, name, init);
        entities.push(entity);
        entity.create();
        return entity;
    }
    
    public function createLayer(name:String, ?init:Hash<Dynamic>):Layer
    {
        var layer:Layer = new Layer(this, name, init);
        layers.push(layer);
        layer.create();
        return layer;
    }
}