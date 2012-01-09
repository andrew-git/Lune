package moonaire.lune;

import moonaire.lune.audio.Audio;
import moonaire.lune.core.Display;
import moonaire.lune.core.Entity;
import moonaire.lune.core.Layer;
import moonaire.lune.core.World;
import moonaire.lune.graphics.Image;
import moonaire.lune.resource.Process;
import moonaire.lune.resource.Resource;
import moonaire.lune.resource.Task;
import moonaire.orbit.Orbit;
import nme.display.Bitmap;
import nme.display.PixelSnapping;
import nme.display.Sprite;
import nme.events.AccelerometerEvent;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.Lib;
import nme.media.Sound;
import nme.text.TextField;
import nme.text.TextFormat;

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
        var script:Orbit = lune.script;
        
        // set classpaths
        script.classpaths.push("assets/");
        
        // create bindings
        script.bind(Lune, "Lune", true);
        script.bind(Display, "Display", true);
        script.bind(Process, "Process", true);
        script.bind(Resource, "Resource", true);
        script.bind(Task, "Task", true);
        
        script.bind(World, "World", true);
        script.bind(Entity, "Entity", true);
        script.bind(Layer, "Layer", true);
        script.bind(Image, "Image", true);
        script.bind(Audio, "Audio", true);
        
        script.bind(Event, "Event", true);
        script.bind(MouseEvent, "MouseEvent", true);
        script.bind(KeyboardEvent, "KeyboardEvent", true);
        script.bind(TouchEvent, "TouchEvent", true);
        script.bind(TouchEvent, "TouchEvent", true);
        script.bind(AccelerometerEvent, "AccelerometerEvent", true);
        
        script.bind(Bitmap, "Bitmap", true);
        script.bind(Sprite, "Sprite", true);
        script.bind(TextField, "TextField", true);
        script.bind(TextFormat, "TextFormat", true);
        script.bind(Sound, "Sound", true);
        
        // start script
        script.require("Main");
    }
}