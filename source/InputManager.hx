package;

import flixel.FlxG;

enum Inputs{
    LEFT;
    RIGHT;
    ATTACK;
    DEFEND;
    DASH;
}

typedef InputFrame = Map<Inputs, Bool>;

class InputManager
{
    public static function EmptyIF():InputFrame {
        return new InputFrame();
    }

    public static function KeyboardIF1():InputFrame {
        var inputFrame = new InputFrame();

        inputFrame.set(Inputs.LEFT,
                       FlxG.keys.anyPressed([A]));

        inputFrame.set(Inputs.RIGHT,
                       FlxG.keys.anyPressed([D]));

        inputFrame.set(Inputs.ATTACK,
                       FlxG.keys.anyPressed([W]));

        inputFrame.set(Inputs.DEFEND,
                       FlxG.keys.anyPressed([S]));

        inputFrame.set(Inputs.DASH,
                       FlxG.keys.anyPressed([E]));
        return inputFrame;
    }

    public static function KeyboardIF2():InputFrame {
        var inputFrame = new InputFrame();

        inputFrame.set(Inputs.LEFT,
                       FlxG.keys.anyPressed([LEFT]));

        inputFrame.set(Inputs.RIGHT,
                       FlxG.keys.anyPressed([RIGHT]));

        inputFrame.set(Inputs.ATTACK,
                       FlxG.keys.anyPressed([UP]));

        inputFrame.set(Inputs.DEFEND,
                       FlxG.keys.anyPressed([DOWN]));

        inputFrame.set(Inputs.DASH,
                       FlxG.keys.anyPressed([SHIFT]));

        return inputFrame;
    }
}