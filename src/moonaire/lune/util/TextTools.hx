package moonaire.lune.util;

using StringTools;

/**
 * ...
 * @author Munir Hussin
 */

class TextTools 
{
    public static inline var EMAIL_REGEX:EReg = ~/^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)+)@(([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)){2,}\.([A-Za-z]){2,4}+$/g;
    
    
    public static function isBlank(s:String):Bool
    {
        return s == null || s.trim().length == 0;
    }
    
    public static function isValidEmail(s:String):Bool
    {
        return EMAIL_REGEX.match(s);
    }
    
    public static function capitalize(word:String, toUpper:Bool):String
    {
        return toUpper ? word.toUpperCase() : word.toLowerCase();
    }
}