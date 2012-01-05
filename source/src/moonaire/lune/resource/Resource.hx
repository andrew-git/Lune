package moonaire.lune.resource;

import nme.Assets;
import nme.display.BitmapData;
import nme.media.Sound;
import nme.text.Font;
import nme.utils.ByteArray;

/**
 * Async resource loader. Say you have some custom data you need to load
 * which requires a lot of processing of the bytearray data, instead of
 * having the screen froze, process it bit by bit over multiple update
 * calls from the engine. This way the screen can update, so you can make
 * loading screens.
 * 
 * Not fully implemented yet.
 * 
 * @author Munir Hussin
 */

class Resource 
{
    private static var image:Hash<BitmapData> = new Hash<BitmapData>();
    private static var data:Hash<ByteArray> = new Hash<ByteArray>();
    private static var font:Hash<Font> = new Hash<Font>();
    private static var sound:Hash<Sound> = new Hash<Sound>();
    private static var text:Hash<String> = new Hash<String>();
    
    
    public function new() 
    {
        
    }
    
    public function loadImage(id:String):BitmapData
    {
        if (image.exists(id))
        {
            return image.get(id);
        }
        else
        {
            var res:BitmapData = Assets.getBitmapData(id);
            image.set(id, res);
            return res;
        }
    }
    
    public function unloadImage(id:String):Void
    {
        if (image.exists(id))
        {
            var res:BitmapData = image.get(id);
            res.dispose();
            image.remove(id);
        }
    }
    
    public function loadData(id:String):ByteArray
    {
        if (data.exists(id))
        {
            return data.get(id);
        }
        else
        {
            var res:ByteArray = Assets.getBytes(id);
            data.set(id, res);
            return res;
        }
    }
    
    public function unloadData(id:String):Void
    {
        if (data.exists(id))
        {
            var res:ByteArray = data.get(id);
            res.clear();
            data.remove(id);
        }
    }
    
    public function loadFont(id:String):Font
    {
        if (font.exists(id))
        {
            return font.get(id);
        }
        else
        {
            var res:Font = Assets.getFont(id);
            font.set(id, res);
            return res;
        }
    }
    
    public function unloadFont(id:String):Void
    {
        if (font.exists(id))
        {
            var res:Font = font.get(id);
            font.remove(id);
        }
    }
    
    public function loadSound(id:String):Sound
    {
        if (sound.exists(id))
        {
            return sound.get(id);
        }
        else
        {
            var res:Sound = Assets.getSound(id);
            sound.set(id, res);
            return res;
        }
    }
    
    public function unloadSound(id:String):Void
    {
        if (sound.exists(id))
        {
            var res:Sound = sound.get(id);
            res.close();
            sound.remove(id);
        }
    }
    
    public function loadText(id:String):String
    {
        if (text.exists(id))
        {
            return text.get(id);
        }
        else
        {
            var res:String = Assets.getText(id);
            text.set(id, res);
            return res;
        }
    }
    
    public function unloadText(id:String):Void
    {
        if (text.exists(id))
        {
            var res:String = text.get(id);
            text.remove(id);
        }
    }
    
}