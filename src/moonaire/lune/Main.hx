package moonaire.lune;

import nme.Lib;

/**
 * ...
 * @author Munir Hussin
 */

class Main 
{
	public static function main() 
	{
        start();
        //test();
	}
    
    public static function test():Void
    {
        // i sometimes test out random things here
    }
    
    public static function start():Void
    {
        var lune:Lune = Lune.instance;
        lune.start();
    }
}