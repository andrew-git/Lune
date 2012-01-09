package moonaire.lune.util;

/**
 * ...
 * @author Munir Hussin
 */

class HashTools 
{
    public static function copy(hash:Hash<Dynamic>):Hash<Dynamic>
    {
        if (hash == null) return null;
        
        var copy:Hash<Dynamic> = new Hash<Dynamic>();
        var keys:Iterator<String> = hash.keys();
        var key:String;
        var value:Dynamic;
        
        while (keys.hasNext())
        {
            key = keys.next();
            value = hash.get(key);
            copy.set(key, value);
        }
        
        return copy;
    }
    
    public static function copyInto(src:Hash<Dynamic>, dest:Hash<Dynamic>):Void
    {
        if (src == null || dest == null) return;
        
        var keys:Iterator<String> = src.keys();
        var key:String;
        var value:Dynamic;
        
        while (keys.hasNext())
        {
            key = keys.next();
            value = src.get(key);
            dest.set(key, value);
        }
    }
    
    /**
     * Copies src to dest.
     * @param	src         The source hashmap
     * @param	dest        The destination hashmap
     * @param	keys        An array of keys to copy
     * @param	copyNull    If the value is null in src, should we copy that over to the destination?
     */
    public static function copyIntoByKeys(src:Hash<Dynamic>, dest:Hash<Dynamic>, keys:Array<String>, copyNull:Bool):Void
    {
        if (src == null || dest == null || keys == null) return;
        
        var i:Int = 0;
        var n:Int = keys.length;
        var key:String;
        var value:Dynamic;
        
        while (i < n)
        {
            key = keys[i];
            value = src.get(key);
            
            if (copyNull || value != null)
            {
                dest.set(key, value);
            }
            
            i++;
        }
    }
    
    
    public static function copyIntoObject(src:Hash<Dynamic>, dest:Dynamic, ?onProcess:Dynamic):Void
    {
        // if dest is not object, don't do anything
        if (src == null || !Reflect.isObject(dest)) return;
        
        var keys:Iterator<String> = src.keys();
        var key:String;
        var value:Dynamic;
        
        if (keys != null)
        {
            while (keys.hasNext())
            {
                key = keys.next();
                value = src.get(key);
                
                // custom callback
                if (Reflect.isFunction(onProcess))
                {
                    value = Reflect.callMethod(null, onProcess, [key, value]);
                }
                Reflect.setField(dest, key, value);
            }
        }
    }
    
    public static function copyPairsIntoObject(src:Array<Dynamic>, dest:Dynamic, ?onProcess:Dynamic):Void
    {
        // if dest is not object, don't do anything
        if (src == null || !Reflect.isObject(dest)) return;
        
        // src is in the form [[a b] [c d] [e f]]
        
        var i:Int = 0;
        var n:Int = src.length;
        var pair:Array<Dynamic>;
        var key:String;
        var value:Dynamic;
    
        while (i < n)
        {
            pair = src[i];
            key = pair[0];
            value = pair[1];
            
            // custom callback
            if (Reflect.isFunction(onProcess))
            {
                value = Reflect.callMethod(null, onProcess, [key, value]);
            }
            
            Reflect.setField(dest, key, value);
            
            i++;
        }
    }
}