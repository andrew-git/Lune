package moonaire.lune;

import moonaire.lune.core.Console;
import moonaire.lune.core.Display;
import moonaire.lune.core.World;
import moonaire.lune.resource.Process;
import moonaire.lune.resource.Resource;
import moonaire.orbit.Orbit;

import nme.events.Event;
import nme.Lib;

/**
 * Lune is a game engine designed to create an abstract between
 * 2D sprites and 3D models (for games in a more-or-less, 2D world).
 * 
 * The idea is that, you can rapidly create a 2D game using a 2D
 * library like NME. And then, later on, you can replace the 2D
 * sprites with 3D models, and use some other 3D library, and
 * with the same code-base, it'll still work.
 * 
 * Lune is not a graphics engine. It is a game engine that abstracts
 * 2D and 3D games by providing similar API for sprites and models.
 * 
 * Currently everything is in 2D using NME, and design decisions
 * will be made with the above idea in mind.
 * 
 * @author Munir Hussin
 */

class Lune 
{
    public var display:Display;
    public var console:Console;
    public var process:Process;
    public var resource:Resource;
    public var script:Orbit;
    
    public var world:World;
    
    private var timePrev:Int;
    private var frameCount:Int;
    private var timePassed:Float;
    public var timeFactor:Float;
    
    public var FPS(default, null):Float;
    
    
    public function new() 
    {
        display = new Display(this);
        console = new Console(this);
        process = new Process();
        resource = new Resource();
        script = new Orbit();
        
        timePrev = 0;
        frameCount = 0;
        timePassed = 1;
        timeFactor = 1;
        
        display.stage.addEventListener(Event.ENTER_FRAME, onUpdate);
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
        var kdt:Float = timeFactor * dt;
        
        // update processes
        process.update(dt, kdt);
        
        // update world
        if (world != null) world.update(dt, kdt);
        
        // calculate fps
        frameCount += 1;
        timePassed += timeDelta;
        
        // every second, update fps
        if (timePassed > 1000)
        {
            FPS = frameCount;
            frameCount = 0;
            timePassed %= 1000;
        }
        
        timePrev = timeCurr;
    }
    
    public function loadWorld(w:World):Void
    {
        // unload the existing world first
        if (world != null) world.destroy();
        
        // initialize the world
        world = w;
    }
    
}