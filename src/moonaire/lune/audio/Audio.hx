package moonaire.lune.audio;

import moonaire.lune.Lune;
import moonaire.lune.util.HashTools;
import moonaire.orbit.Function;
import moonaire.orbit.structs.DList;
import moonaire.orbit.structs.DListIterator;
import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.media.SoundTransform;

/**
 * ...
 * @author Munir Hussin
 */

class Audio implements Dynamic
{
    // base stuff
    public static var defs:Hash<Hash<Dynamic>> = new Hash<Hash<Dynamic>>();
    public static var count:Int = 0;
    public var lune:Lune;
    
    // static properties
    public var settings:Hash<Dynamic>;
    
    // internal properties
    var start:Float;
    var loop:Int;
    var transform:SoundTransform;
    var sound:Sound;
    var channels:Array<SoundChannel>;
    
    // base properties
    public var isActive:Bool;
    public var isDestroyed(default, null):Bool;
    public var hasDisposed(default, null):Bool;
    
    // events
    public var onCreate:Dynamic;
    public var onDestroy:Dynamic;
    public var onUpdate:Dynamic;
    public var onSort:Dynamic;
    
    
    public function new(name:String, ?init:Hash<Dynamic>)
    {
        //super();
        
        // base initialization
        this.lune = Lune.instance;
        
        // internal properties initialization
        channels = new Array<SoundChannel>();
        
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
                var sndFile:String = settings.get("sound");
                
                if (sndFile != null)
                {
                    sound = lune.resource.loadSound(sndFile);
                    //sound = Assets.getSound(sndFile);
                    
                    var loop:Bool = settings.get("smoothing");
                }
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
            if (sound != null) sound.close();
            
            settings = null;
            lune = null;
            count--;
        }
    }
    
    public function onPlayComplete(event:Event):Void
    {
        if (loop != 0)
        {
            loop--;
            channels.remove(event.currentTarget);
            play(start, loop, transform);
        }
    }
    
    public function play(?start:Float = 0, ?loop:Int = 0, ?transform:SoundTransform):SoundChannel
    {
        if (sound != null)
        {
            this.start = start;
            this.loop = loop;
            this.transform = transform;
            
            var channel:SoundChannel = sound.play(start, 0, transform);
            channels.push(channel);
            channel.addEventListener( Event.SOUND_COMPLETE, onPlayComplete );
            return channel;
        }
        
        return null;
    }
    
    public function stop():Void
    {
        var channel:SoundChannel;
        loop = 0;
        
        while (channels.length > 0)
        {
            channel = channels.pop();
            channel.stop();
        }
    }
}