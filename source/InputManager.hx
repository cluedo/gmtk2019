package;

import flixel.FlxG;

enum Inputs{
    LEFT;
    RIGHT;
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

        return inputFrame;
    }

    public static function KeyboardIF2():InputFrame {
        var inputFrame = new InputFrame();

        inputFrame.set(Inputs.LEFT,
                       FlxG.keys.anyPressed([LEFT]));

        inputFrame.set(Inputs.RIGHT,
                       FlxG.keys.anyPressed([RIGHT]));

        return inputFrame;
    }
}