package moonaire.lune.core;

/**
 * ...
 * @author Munir Hussin
 */

class Entity 
{
    public var isActive:Bool;
    public var isTrash:Bool;
    
    public function new() 
    {
        
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