package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

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

    public static var PLAYER_ARROW_COLORS = [
        PlayerType.PLAYER_ONE => FlxColor.CYAN,
        PlayerType.PLAYER_TWO => FlxColor.LIME,
    ];
    public static var ARROW_OFFSET:Float = 3;
    public static var ARROW_WIDTH:Float = 5;

    public static var PLAYER_OFFSETS = [
        PlayerType.PLAYER_ONE => 0.2,
        PlayerType.PLAYER_TWO => 0.8 - PLAYER_SIZE,
    ];

    // Whether the players start facing right
    public static var PLAYER_INITIAL_DIRECTIONS = [
        PlayerType.PLAYER_ONE => true,
        PlayerType.PLAYER_TWO => false,
    ];

    public var playerType:PlayerType;
    public var inputType:InputType;

    public var activeAttacks:List<Attack>;
    public var activeHitboxes:List<Hitbox>;

    public var speed:Float = 0;
    public var facingRight:Bool;

    public var arrowSprite:FlxSprite;

    public function left():Float {
        return Stage.toUnitsOffset(x);
    }
    
    public function center():Float {
        return Stage.toUnitsOffset(x) + 0.5 * PLAYER_SIZE;
    }

    public function right():Float {
        return Stage.toUnitsOffset(x) + PLAYER_SIZE;
    }

    public function new(stage:Stage,
                        playerType:PlayerType,
                        inputType:InputType)
    {
        super();

        this.playerType = playerType;
        this.inputType = inputType;

        makeGraphic(PLAYER_WIDTH, 
                    PLAYER_HEIGHT, 
                    PLAYER_COLORS[playerType]);

        x = Stage.toPixelsOffset(PLAYER_OFFSETS[playerType]);
        y = Stage.currentStage.y;

        activeHitboxes = new List<Hitbox>();
        activeAttacks = new List<Attack>();

        this.facingRight = PLAYER_INITIAL_DIRECTIONS[playerType];

        arrowSprite = new FlxSprite();
        arrowSprite.makeGraphic(Std.int(this.width), Std.int(this.height), FlxColor.TRANSPARENT, true);
        var vertices = new Array<FlxPoint>();
        vertices.push(new FlxPoint(ARROW_OFFSET, this.height/2));
        vertices.push(new FlxPoint(this.height/2 + ARROW_OFFSET, 0));
        vertices.push(new FlxPoint(this.height/2 + ARROW_OFFSET + ARROW_WIDTH, 0));
        vertices.push(new FlxPoint(ARROW_OFFSET + ARROW_WIDTH, this.height/2));
        vertices.push(new FlxPoint(this.height/2 + ARROW_OFFSET + ARROW_WIDTH, this.height));
        vertices.push(new FlxPoint(this.height/2 + ARROW_OFFSET, this.height));
        arrowSprite.drawPolygon(vertices, PLAYER_ARROW_COLORS[playerType]);
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

    public function updateArrow():Void {
        arrowSprite.x = x;
        arrowSprite.y = y;

        arrowSprite.flipX = facingRight;
    }

    override public function update(elapsed:Float):Void
	{
        movement(getInputFrame());
		super.update(elapsed);

        x = FlxMath.bound(x, Stage.currentStage.x, Stage.currentStage.x + Stage.STAGE_WIDTH - PLAYER_WIDTH);
        updateArrow();
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
        if (speed > 0) {
            facingRight = true;
        } else if (speed < 0) {
            facingRight = false;
        }

        velocity.set(speed, 0);

        if (inputFrame.get(InputManager.Inputs.ATTACK)) {
            // stopgap until we implement attackLag
            if (activeAttacks.isEmpty()) {
                var attack = new Attack.JabAttack(this);
                activeAttacks.add(attack);
            } 
        }
    }

    public function removeStale() {
        for (hitbox in activeHitboxes) {
			if (!hitbox.alive()) hitbox.sprite.kill();
		}
		activeHitboxes = activeHitboxes.filter(function(hitbox) return hitbox.alive());

        activeAttacks = activeAttacks.filter(function(attack) return attack.alive());
    }

    public function tick() {
        for (hitbox in activeHitboxes) {
			hitbox.tick();
		}

        // tick attacks after hitboxes or hitbox will tick when created
        for (attack in activeAttacks) {
            attack.tick();
        }
    }

    public function collide(hitbox:Hitbox) {
        if (this == hitbox.player) return;

        var hbox_left = hitbox.center - hitbox.radius;
        var hbox_right = hitbox.center + hitbox.radius;

        if (right() < hbox_left || left() > hbox_right) {
            return;
        } 

        trace("HIT!");
        hitbox.kill();
    }
}