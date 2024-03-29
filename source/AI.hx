package;

import flixel.math.FlxRandom;

class AI
{
    public var me:Player;
    public var other:Player;
    
    public var random:FlxRandom;

    public function new(me:Player, other:Player) {
        this.me = me;
        this.other = other;

        random = new FlxRandom();
    }

    public function getInput():InputManager.InputFrame {
        return InputManager.EmptyIF();
    }
}

class AttackAI extends AI
{
    override public function getInput():InputManager.InputFrame {
        var input = InputManager.EmptyIF();

        if (other.center() < me.center()) {
            input[InputManager.Inputs.LEFT] = true;
        } else if (other.center() > me.center()) {
            input[InputManager.Inputs.RIGHT] = true;
        }

        var attackTrigger:Float = 2*Hitbox.SwordHitbox.SWORD_HITBOX_RADIUS + Player.PLAYER_SIZE + 0.01;
        if (Math.abs(other.center() - me.center()) < 
                attackTrigger) {
            if (random.bool()) {
                input[InputManager.Inputs.DEFEND] = true;
            } else {
                input[InputManager.Inputs.ATTACK] = true;
            }
            
        }

        if (random.bool(1)) {
            input[InputManager.Inputs.DASH] = true;
        }

        return input;
    }
}