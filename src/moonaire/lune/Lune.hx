package moonaire.lune;

import moonaire.lune.audio.Audio;
import moonaire.lune.core.Console;
import moonaire.lune.core.Display;
import moonaire.lune.core.Entity;
import moonaire.lune.core.Layer;
import moonaire.lune.core.World;
import moonaire.lune.graphics.Image;
import moonaire.lune.resource.Process;
import moonaire.lune.resource.Resource;
import moonaire.lune.resource.Task;
import moonaire.orbit.Orbit;
import moonaire.orbit.structs.DList;
import moonaire.orbit.structs.DListIterator;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.AccelerometerEvent;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.media.Sound;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;

import nme.events.Event;
import nme.Lib;

/**
 * Lune is a game engine.
 * 
 * @author Munir Hussin
 */

class Lune 
{
    public static var instance(getInstance, null):Lune;
    
    public var display:Display;
    public var console:Console;
    public var process:Process;
    public var resource:Resource;
    public var script:Orbit;
    
    private var worlds:DList<World>;
    private var worldIterator:DListIterator<World>;
    
    private var timePrev:Int;
    private var frameCount:Int;
    private var timePassed:Float;
    public var timeFactor:Float;
    
    public var FPS(default, null):Float;
    private var debugText:TextField;
    
    
    public function new() 
    {
        display = new Display(this);
        console = new Console(this);
        process = new Process();
        resource = new Resource(this);
        script = new Orbit();
        
        worlds = new DList<World>();
        worldIterator = worlds.iterator();
        
        timePrev = 0;
        frameCount = 0;
        timePassed = 1;
        timeFactor = 1;
        
        display.stage.addEventListener(Event.ENTER_FRAME, onUpdate);
        
        setupDebug();
        setupScript();
    }
    
    private static function getInstance():Lune
    {
        if (instance == null) instance = new Lune();
        return instance;
    }
    
    public function start():Void
    {
        // start script
        script.require("Main");
    }
    
    private function setupDebug():Void
    {
        var font:Font = resource.loadFont("assets/lune/fonts/VeraMono.ttf");
        var format:TextFormat = new TextFormat(font.fontName);
        format.size = 12;
        format.color = 0x000000;
        
        debugText = new TextField();
        debugText.defaultTextFormat = format;
        debugText.embedFonts = true;
        debugText.selectable = false;
        debugText.x = 0;
        debugText.y = 0;
        //debugText.textColor = 0xff0000;
        debugText.text = "Hello";
        
        display.debug.addChild(debugText);
    }
    
    private function setupScript():Void
    {
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
        script.bind(AccelerometerEvent, "AccelerometerEvent", true);
        
        script.bind(Bitmap, "Bitmap", true);
        script.bind(Sprite, "Sprite", true);
        script.bind(TextField, "TextField", true);
        script.bind(TextFormat, "TextFormat", true);
        script.bind(Sound, "Sound", true);
    }
    
    
    private function onUpdate(event:Event):Void
    {
        // calculate elapsed time
        var timeCurr:Int = Lib.getTimer();
        var timeDelta:Int = timeCurr - timePrev;
        
        // error checking
        if (timeDelta < 0) timeDelta += 1000;
        var dt:Float = timeDelta / 1000;
        
        // speed limit check
        if (dt > 0.05) dt = 0.05;
        
        // bullet time!
        var fdt:Float = timeFactor * dt;
        
        // update processes
        process.update(dt, fdt);
        
        // update worlds
        var world:World;
        worldIterator.first();
        
        while (worldIterator.hasNext())
        {
            world = worldIterator.peek();
            
            if (world.isActive && !world.isDestroyed)
            {
                world.update(dt, fdt);
            }
                
            if (world.isDestroyed)
            {
                world.dispose();
                worldIterator.remove();
                display.view.removeChild(world);
            }
            
            worldIterator.next();
        }
        
        // calculate fps
        frameCount += 1;
        timePassed += timeDelta;
        
        // every second, update fps
        if (timePassed > 1000)
        {
            FPS = frameCount;
            frameCount = 0;
            timePassed %= 1000;
            debugText.text = "FPS: " + FPS;
        }
        
        timePrev = timeCurr;
    }
    
    public function createWorld(name:String, ?init:Hash<Dynamic>):World
    {
        var world:World = new World(this, name, init);
        worlds.push(world);
        world.create();
        return world;
    }
    
}