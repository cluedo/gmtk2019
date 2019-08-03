package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
    public static var PLAYER_SIZE:Float = 0.05;
    public static var PLAYER_WIDTH:Int = 
        Math.round(PLAYER_SIZE * Stage.STAGE_WIDTH);
    public static var PLAYER_HEIGHT:Int = Stage.STAGE_HEIGHT;

    public var stage:Stage;
    public var game:PlayState;

    public var speed:Float = 0;

    public var firstPlayer:Bool;

    public function new(stage:Stage, ?X:Float=0, firstPlayer_:Bool=true)
    {
        super();

        this.stage = stage;
        firstPlayer = firstPlayer_;
        if(firstPlayer) {
            makeGraphic(PLAYER_WIDTH, 
                        PLAYER_HEIGHT, 
                        FlxColor.RED);
        }
        else {
            makeGraphic(PLAYER_WIDTH, 
                        PLAYER_HEIGHT, 
                        FlxColor.BLUE);
        }

        x = stage.x + X;
        y = stage.y;
    }

    override public function update(elapsed:Float):Void
	{
        movement();
		super.update(elapsed);

        x = FlxMath.bound(x, stage.x, stage.x + Stage.STAGE_WIDTH - PLAYER_WIDTH);
	}

    public function movement():Void
    {
        // adapted from http://haxeflixel.com/documentation/groundwork/
        var left:Bool = false;
        var right:Bool = false;

        if(firstPlayer) {
            left = FlxG.keys.anyPressed([LEFT]);
            right = FlxG.keys.anyPressed([RIGHT]);
        }
        else {
            left = FlxG.keys.anyPressed([A]);
            right = FlxG.keys.anyPressed([D]);
        }



        if (left) {
            speed -= 20;
        } else if (right) {
            speed += 20;
        } else {
            if (speed > 0) {
                speed = Math.max(0, speed - 10);
            } else {
                speed = Math.min(0, speed + 10);
            }
        }
        
        speed = FlxMath.bound(speed, -100, 100);
        velocity.set(speed, 0);
    }

}