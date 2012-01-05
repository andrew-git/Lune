package moonaire.lune.resource;

/**
 * ...
 * @author Munir Hussin
 */

class Task 
{
    public var name:String;
    public var i:Int;
    public var n:Int;
    
    public var progress(getProgress, null):Float;
    public var hasCompleted(getHasCompleted, null):Bool;
    
    public function new(name:String) 
    {
        this.name = name;
        this.i = 0;
        this.n = 0;
    }
    
    public dynamic function onStart():Void
    {
        // this is used to figure out the values of i and n
        // after this function has exited, update the value
        // of i in the onExecute method, but DO NOT modify n.
    }
    
    public dynamic function onComplete():Void
    {
        // do cleanup or whatever
    }
    
    public dynamic function onExecute():Void
    {
        
    }
    
    private function getProgress():Float
    {
        return i / n;
    }
    
    private function getHasCompleted():Bool
    {
        return i >= n;
    }
    
}