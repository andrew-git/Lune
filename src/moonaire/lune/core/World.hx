package moonaire.lune.core;

import moonaire.lune.Lune;
import moonaire.orbit.structs.DList;
import moonaire.orbit.structs.DListIterator;
import nme.display.Sprite;

/**
 * ...
 * @author Munir Hussin
 */

class World extends Sprite
{
    public static var defs:Hash<Dynamic> = new Hash<Dynamic>();
    public static var count:Int = 0;
    
    public var lune:Lune;
    
    private var entities:DList<Entity>;
    private var entityIterator:DListIterator<Entity>;
    
    private var layers:DList<Layer>;
    private var layerIterator:DListIterator<Layer>;
    
    
    public function new(lune:Lune) 
    {
        super();
        
        this.lune = lune;
        
        entities = new DList<Entity>();
        entityIterator = entities.iterator();
        
        layers = new DList<Layer>();
        layerIterator = layers.iterator();
    }
    
    public function create():Void
    {
        
    }
    
    public function destroy():Void
    {
        
    }
    
    public function update(dt:Float, kdt:Float):Void
    {
        // raise update event
        onUpdate(dt, kdt);
        
        // update entities
        var entity:Entity;
        entityIterator.first();
        
        while (entityIterator.hasNext())
        {
            entity = entityIterator.peek();
            
            if (entity.isActive && !entity.isTrash)
                entity.update(dt, kdt);
                
            if (entity.isTrash)
            {
                entity.destroy();
                entityIterator.remove();
            }
            
            entityIterator.next();
        }
        
        // update layers
        /*
        var layer:Layer;
        layerIterator.first();
        
        while (layerIterator.hasNext())
        {
            layer = layerIterator.peek();
            
            if (layer.isActive && !layer.isTrash)
                layer.update(dt, kdt);
                
            if (layer.isTrash)
            {
                layer.destroy();
                layerIterator.remove();
            }
            
            layerIterator.next();
        }*/
        
    }
    
    public dynamic function onCreate():Void
    {
        
    }
    
    public dynamic function onDestroy():Void
    {
        
    }
    
    public dynamic function onUpdate(dt:Float, kdt:Float):Void
    {
        
    }
    
}