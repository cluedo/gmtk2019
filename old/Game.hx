package;

import flixel.util.FlxColor;

class Game
{
    public function new(){
        
    }

    public var stageWidth:Float = 1.0;

    public function render(x:Float):FlxColor {
        if (x < 0.5) {
            return FlxColor.RED;
        } else {
            return FlxColor.BLUE;
        }
    }
}

class GameObject
{

}

class Player
{
    public var x:Float = 0.25;
    public var width:Float = 0.05;

    public function move(input:InputFrame) 
    {

    }

    public function render(x:Float):FlxColor {
        
    }
}

class InputFrame
{
    public var left:Bool = false;
    public var right:Bool = false;
}