package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

enum PlayerType{
    PLAYER_ONE;
    PLAYER_TWO;
}

enum InputType {
    KEYBOARD_ONE;
    KEYBOARD_TWO;
}

class Player extends FlxSprite
{
    public static var PLAYER_SIZE:Float = 0.05;
    public static var PLAYER_WIDTH:Int = 
        Math.round(PLAYER_SIZE * Stage.STAGE_WIDTH);
    public static var PLAYER_HEIGHT:Int = Stage.STAGE_HEIGHT;

    public static var PLAYER_COLORS = [
        PlayerType.PLAYER_ONE => FlxColor.BLUE,
        PlayerType.PLAYER_TWO => FlxColor.GREEN,
    ];

    public static var PLAYER_OFFSETS = [
        PlayerType.PLAYER_ONE => 0.2,
        PlayerType.PLAYER_TWO => 0.8 - PLAYER_SIZE,
    ];

    public var playerType:PlayerType;
    public var inputType:InputType;

    public var stage:Stage;
    public var game:PlayState;

    public var speed:Float = 0;

    public function toPixels(w:Float):Float {
        return Stage.STAGE_WIDTH * w;
    }

    public function position():Float {
        return ((x - stage.x) / Stage.STAGE_WIDTH) + 0.5 * PLAYER_SIZE;
    }

    public function new(stage:Stage,
                        playerType:PlayerType,
                        inputType:InputType)
    {
        super();

        this.stage = stage;
        this.playerType = playerType;
        this.inputType = inputType;

        makeGraphic(PLAYER_WIDTH, 
                    PLAYER_HEIGHT, 
                    PLAYER_COLORS[playerType]);

        x = stage.x + toPixels(PLAYER_OFFSETS[playerType]);
        y = stage.y;
    }

    public function getInputFrame():InputManager.InputFrame {
        switch (inputType) {
            case KEYBOARD_ONE:
                return InputManager.KeyboardIF1();
            case KEYBOARD_TWO:
                return InputManager.KeyboardIF2();
        }
        return InputManager.EmptyIF();
    }

    override public function update(elapsed:Float):Void
	{
        movement(getInputFrame());
		super.update(elapsed);

        x = FlxMath.bound(x, stage.x, stage.x + Stage.STAGE_WIDTH - PLAYER_WIDTH);
	}

    public function movement(inputFrame:InputManager.InputFrame):Void
    {
        // adapted from http://haxeflixel.com/documentation/groundwork/
        if (inputFrame.get(InputManager.Inputs.LEFT)) {
            speed -= 20;
        } else if (inputFrame.get(InputManager.Inputs.RIGHT)) {
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