package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
using flixel.util.FlxSpriteUtil;
import flixel.system.FlxSound;
import flixel.FlxG;

enum PlayerType {
    PLAYER_ONE;
    PLAYER_TWO;
}

enum InputType {
    KEYBOARD_ONE;
    KEYBOARD_TWO;
    AI;
}

enum PlayerState {
    IDLE;
    ATTACK_LAG(frames:Int);
    HIT_STUN(frames:Int);
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
    public static var ARROW_WIDTH:Float = 7;

    public static var PLAYER_OFFSETS = [
        PlayerType.PLAYER_ONE => 0.2,
        PlayerType.PLAYER_TWO => 0.8 - PLAYER_SIZE,
    ];

    // Whether the players start facing right
    public static var PLAYER_INITIAL_DIRECTIONS = [
        PlayerType.PLAYER_ONE => true,
        PlayerType.PLAYER_TWO => false,
    ];

    public static var GROUND_ACCELERATION = 0.05;
    public static var GROUND_DRAG = 0.02;
    public static var GROUND_MAX_SPEED = 0.2;
    public static var AIR_DRAG = 0.02;
    public static var AIR_MAX_SPEED = 1.0;
    public static var AIR_REPEL = 0.05;
    public static var DASH_TIMER = 240;
    public static var DASH_LENGTH = 0.11;

    public var stage:Stage;

    public var playerType:PlayerType;
    public var inputType:InputType;

    public var playerAI:AI;

    public var playerState:PlayerState = IDLE;

    public var activeAttacks:List<Attack>;
    public var activeHitboxes:List<Hitbox>;

    public var groundSpeed:Float = 0;
    public var airSpeed:Float = 0;
    public var dashTimer:Int = 0;

    public var facingRight:Bool;

    public var invulnerable:Bool = false;

    public var arrowSprite:FlxSprite;

    public static var _hit_sound;
    public static var _block_sound;
    public static var _attack_sound;
    public static var _defend_sound;
    public static var _death_sound;
    public static var _dash_sound;

    public function left():Float {
        return Stage.toUnitsOffset(x);
    }
    
    public function center():Float {
        return Stage.toUnitsOffset(x) + 0.5 * PLAYER_SIZE;
    }

    public function right():Float {
        return Stage.toUnitsOffset(x) + PLAYER_SIZE;
    }

    public function face(?offset:Float=0):Float {
        if (facingRight) {
            return right() + offset;
        } else {
            return left() - offset;
        }
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
        updateArrow();
        
        _hit_sound = FlxG.sound.load(AssetPaths.hit__wav, 0.3);
        _block_sound = FlxG.sound.load(AssetPaths.block__wav, 0.3);
        _attack_sound = FlxG.sound.load(AssetPaths.attack__wav, 0.3);
        _defend_sound = FlxG.sound.load(AssetPaths.defend__wav, 0.3);
        _death_sound = FlxG.sound.load(AssetPaths.death__wav, 0.3);
        _dash_sound = FlxG.sound.load(AssetPaths.dash__wav, 0.3);
    }

    public function getInputFrame():InputManager.InputFrame {
        switch (inputType) {
            case KEYBOARD_ONE:
                return InputManager.KeyboardIF1();
            case KEYBOARD_TWO:
                return InputManager.KeyboardIF2();
            case AI:
                if (playerAI == null) {
                    return InputManager.EmptyIF();
                } else {
                    return playerAI.getInput();
                }
        }
        return InputManager.EmptyIF();
    }

    public function updateArrow():Void {
        arrowSprite.x = x;
        arrowSprite.y = y;

        arrowSprite.flipX = facingRight;
    }

    public function checkDeath():Void {
        if (x < Stage.currentStage.x || x + PLAYER_WIDTH > Stage.currentStage.x + Stage.STAGE_WIDTH) {
            // We died!
            _death_sound.play();
            stage.someoneIsDying = true;
            FlxTween.tween(arrowSprite, {alpha: 0}, 1);
            FlxTween.tween(this, {alpha: 0}, 1, {onComplete: finishDeath});
        }
    }

    public function finishDeath(tween:FlxTween):Void {
        if (playerType == PLAYER_ONE) {
            Registry.player2Score += 1;
            Registry.lastPlayerWon = 2;
        } else if (playerType == PLAYER_TWO) {
            Registry.player1Score += 1;
            Registry.lastPlayerWon = 1;
        }
        stage.someoneIsDead = true;
    }

    override public function update(elapsed:Float):Void
	{
        if (stage.isPaused()) {
            return;
        }

        movement(getInputFrame());
		super.update(elapsed);

        checkDeath();

        x = FlxMath.bound(x, Stage.currentStage.x, Stage.currentStage.x + Stage.STAGE_WIDTH - PLAYER_WIDTH);
        updateArrow();
	}

    public function applyDrag() {
        if (groundSpeed > 0) {
            groundSpeed = Math.max(0, groundSpeed - GROUND_DRAG);
        } else {
            groundSpeed = Math.min(0, groundSpeed + GROUND_DRAG);
        }
        groundSpeed = FlxMath.bound(groundSpeed, -GROUND_MAX_SPEED, GROUND_MAX_SPEED);

        if (airSpeed > 0) {
            airSpeed = Math.max(0, airSpeed - AIR_DRAG);
        } else {
            airSpeed = Math.min(0, airSpeed + AIR_DRAG);
        }
        airSpeed = FlxMath.bound(airSpeed, -AIR_MAX_SPEED, AIR_MAX_SPEED);
    }

    public function dash()
    {
        if (facingRight) {
            x += Stage.toPixels(DASH_LENGTH);
        } else {
            x -= Stage.toPixels(DASH_LENGTH);
        }
    }

    public function movement(inputFrame:InputManager.InputFrame):Void
    {
        switch (playerState) {
            case IDLE:
                if (inputFrame.get(InputManager.Inputs.LEFT)) {
                    groundSpeed -= GROUND_ACCELERATION;
                } else if (inputFrame.get(InputManager.Inputs.RIGHT)) {
                    groundSpeed += GROUND_ACCELERATION;
                } 

                if (inputFrame.get(InputManager.Inputs.ATTACK)) {
                    var attack = new Attack.SwordAttack(this);
                    _attack_sound.play();
                    activeAttacks.add(attack);
                    playerState = ATTACK_LAG(attack.attackLag);
                }

                var turnOffInvulnerability:FlxTimer->Void = function(t:FlxTimer){
                    invulnerable = false;
                    replaceColor(FlxColor.WHITE, PLAYER_COLORS[playerType]);
                };
                
                if (inputFrame.get(InputManager.Inputs.DEFEND)) {
                    invulnerable = true;
                    replaceColor(PLAYER_COLORS[playerType], FlxColor.WHITE);
                    _block_sound.play();
                    playerState = ATTACK_LAG(30);
                    new FlxTimer().start(0.3, turnOffInvulnerability, 1);
                }

                if (inputFrame.get(InputManager.Inputs.DASH)) {
                    if (dashTimer == 0) {
                        _dash_sound.play();
                        dash();
                        dashTimer = DASH_TIMER;
                    }
                }

            case ATTACK_LAG(frames):
                if (frames == 1) {
                    playerState = IDLE;
                } else {
                    playerState = ATTACK_LAG(frames-1);
                }
            
            case HIT_STUN(frames):
                if (frames == 1) {
                    playerState = IDLE;
                } else {
                    playerState = HIT_STUN(frames-1);
                }
        }

        if (groundSpeed > 0) {
            facingRight = true;
        } else if (groundSpeed < 0) {
            facingRight = false;
        }

        applyDrag();
        var speed = groundSpeed + airSpeed;

        velocity.set(Stage.toPixels(speed), 0);
    }



    public function removeStale() {
        /*
        for (hitbox in activeHitboxes) {
			if (!hitbox.alive()) hitbox.sprite.kill();
        }*/
		activeHitboxes = activeHitboxes.filter(function(hitbox) return hitbox.alive());

        activeAttacks = activeAttacks.filter(function(attack) return attack.alive());
    }



    public function tick() {
        if (stage.isPaused()) {
            return;
        }

        for (hitbox in activeHitboxes) {
			hitbox.tick();
		}

        // tick attacks after hitboxes or hitbox will tick when created
        for (attack in activeAttacks) {
            attack.tick();
        }

        if (dashTimer > 0) dashTimer--;
    }

    public function interrupt() {
        for (attack in activeAttacks) {
            attack.interrupt();
        }
    }

    public function collide(hitbox:Hitbox) {
        if (this == hitbox.player) return;

        if(this.invulnerable) {
            _block_sound.play();
            return;
        }

        _hit_sound.play();

        var hbox_left = hitbox.center - hitbox.radius;
        var hbox_right = hitbox.center + hitbox.radius;

        if (right() < hbox_left || left() > hbox_right) {
            return;
        } 

        playerState = HIT_STUN(hitbox.hitstun);
        interrupt();

        if (center() < hitbox.anchor) {
            airSpeed -= hitbox.strength;
        } else {
            airSpeed += hitbox.strength;
        }
        hitbox.kill();
    }

    public function collidePlayers(player:Player) {
        if (right() < player.left() || left() > player.right()) {
            return;
        }

        if (center() < player.center()) {
            airSpeed -= AIR_REPEL;
        } else {
            airSpeed += AIR_REPEL;
        }
    }
}