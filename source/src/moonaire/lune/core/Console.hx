package moonaire.lune.core;

import moonaire.lune.Lune;

/**
 * Console model. To be used with the appropriate console view.
 * @author Munir Hussin
 */

class Console 
{
    private static inline var INPUT_MAXSIZE:Int = 10;
    
    private var lune:Lune;
    public var messages:String;
    public var inputs:Array<Dynamic>;
    
    public function new(lune:Lune) 
    {
        this.lune = lune;
        messages = "";
        inputs = new Array<Dynamic>();
    }
    
    /**
     * Input a command to be processed by the console
     * @param	cmd
     */
    public function input(cmd:String):Void
    {
        inputs.push(cmd);
        messages += "> " + cmd;
        lune.script.read(cmd);
    }
    
    public function trim():Void
    {
        while (inputs.length > INPUT_MAXSIZE)
        {
            inputs.shift();
        }
    }
    
}