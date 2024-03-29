package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import flixel.addons.display.FlxBackdrop;
import Player.PlayerType;

class PlayState extends FlxState
{
	public static var currentGame:PlayState;

	public var stage:Stage;

	public var player1:Player;
	public var player2:Player;

	public var activeHitboxes:List<Hitbox>;

	public var inPreamble:Bool;
	public var preambleText:FlxText;

    public var controlsText:FlxText;

	public var countdownText:FlxText;
	public var timeToGameStart:Float;
	public var countdownBeepSound:FlxSound;

	public var player1ScoreText:FlxText;
	public var player2ScoreText:FlxText;

    public var bgImage:FlxBackdrop;

	override public function create() {
		super.create();
		currentGame = this;

		bgColor = FlxColor.WHITE;

		stage = new Stage();
		add(stage);
		stage.screenCenter();

		player1 = new Player(stage,
							 Player.PlayerType.PLAYER_ONE,
							 Player.InputType.KEYBOARD_ONE);

		if (Registry.singlePlayer) {
			player2 = new Player(stage,
							 Player.PlayerType.PLAYER_TWO,
							 Player.InputType.AI);
			player2.playerAI = new AI.AttackAI(player2, player1);
		} else {
			player2 = new Player(stage,
							Player.PlayerType.PLAYER_TWO,
							Player.InputType.KEYBOARD_TWO);
		}
		
		add(player1.trail);
		add(player2.trail);

		add(player1);
		add(player1.arrowSprite);
		add(player1.disabledSprite);

		add(player2);
		add(player2.arrowSprite);
		add(player2.disabledSprite);


		activeHitboxes = new List<Hitbox>();

		inPreamble = true;
		preambleText = new FlxText();
		preambleText.setFormat(AssetPaths.squaredpixel__ttf, 32, FlxColor.BLACK, FlxTextAlign.CENTER);
		add(preambleText);

        controlsText = new FlxText();
		controlsText.setFormat(AssetPaths.squaredpixel__ttf, 32, FlxColor.BLACK, FlxTextAlign.LEFT);
		add(controlsText);
        controlsText.visible = false;

		countdownText = new FlxText();
		countdownText.setFormat(AssetPaths.squaredpixel__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(countdownText);
		timeToGameStart = 3;
		countdownBeepSound = FlxG.sound.load(AssetPaths.block__wav, 0.1);

		player1ScoreText = new FlxText();
		player1ScoreText.setFormat(AssetPaths.squaredpixel__ttf, 64, Player.PLAYER_COLORS[PlayerType.PLAYER_ONE], FlxTextAlign.CENTER);
		add(player1ScoreText);

		player2ScoreText = new FlxText();
		player2ScoreText.setFormat(AssetPaths.squaredpixel__ttf, 64, Player.PLAYER_COLORS[PlayerType.PLAYER_TWO], FlxTextAlign.CENTER);
		add(player2ScoreText);
		updateScoreText();

        bgImage = new FlxBackdrop(AssetPaths.background__png);
        add(bgImage);
        bgImage.visible = false;
	}

	public function updateCountdown(elapsed:Float) {
		if (stage.gameStarted) {
			return;
		}

		timeToGameStart -= elapsed;
		var newText:String = Std.string(Math.ceil(timeToGameStart));
        if (countdownText.text != newText)
        {
            countdownBeepSound.play();
        }
        countdownText.text = newText;
		countdownText.screenCenter();

		if (timeToGameStart <= 0) {
			stage.gameStarted = true;
			countdownText.visible = false;
			if (FlxG.sound.music == null) {
				FlxG.sound.playMusic(AssetPaths.maybe_1d_song__ogg, .5, true);
			} else {
				FlxG.sound.resume();
			}
		}
	}

	public function updateScoreText() {
		player1ScoreText.text = Std.string(Registry.player1Score);
		player2ScoreText.text = Std.string(Registry.player2Score);

		player1ScoreText.x = stage.x - (player1ScoreText.width / 2);
		player1ScoreText.y = FlxG.height/4;

		player2ScoreText.x = stage.x + Stage.STAGE_WIDTH - (player2ScoreText.width / 2);
		player2ScoreText.y = FlxG.height/4;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (inPreamble) {
			// magic spacing don't touch
			controlsText.text = "\n\n\n\n\n\n\n\n        Left:       A                                   LEFT\n        Right:     D                                   RIGHT\n        Attack: W                                   UP\n        Dodge:    S                                   DOWN\n        Dash:       E                                   SHIFT";
			if(Registry.singlePlayer) {
                controlsText.text = "\n\n\n\n\n\n\n\n        Left:       A\n        Right:     D\n        Attack: W\n        Dodge:    S\n        Dash:       E";
            }
            controlsText.visible = true;
			if (Registry.lastPlayerWon == 0) {
				preambleText.text = "First to 5 wins.\nPress space to start.";
			} else if (Registry.player1Score == 5 || Registry.player2Score == 5) {
                if(Registry.lastPlayerWon == 1) {
                    bgImage = new FlxBackdrop(AssetPaths.player1__png);
                }
                else {
                    bgImage = new FlxBackdrop(AssetPaths.player2__png);
                }
                add(bgImage);
                bgImage.visible = true;
                preambleText.text = "Player " + Std.string(Registry.lastPlayerWon) + " wins!\nPress space to play again.\nPress R for the menu.";
            }
            else {
				preambleText.text = "Player " + Std.string(Registry.lastPlayerWon) + " scores!\nPress space to continue.";
			}

			if (Registry.lastPlayerWon == 1) {
				preambleText.color = Player.PLAYER_COLORS[PlayerType.PLAYER_ONE];
			} else if (Registry.lastPlayerWon == 2) {
				preambleText.color = Player.PLAYER_COLORS[PlayerType.PLAYER_TWO];
			}
			preambleText.x = (FlxG.width - preambleText.width) / 2;
			preambleText.y = FlxG.height/6;
			if (FlxG.keys.pressed.SPACE) {
				inPreamble = false;
				preambleText.visible = false;
                controlsText.visible = false;
                if (Registry.player1Score == 5 || Registry.player2Score == 5) {
                    Registry.player1Score = 0;
                    Registry.player2Score = 0;
                    Registry.lastPlayerWon = 0;
                }
                bgImage.visible = false;
			}
            if (FlxG.keys.pressed.R && (Registry.player1Score == 5 || Registry.player2Score == 5)) {
                preambleText.visible = false;
                controlsText.visible = false;
                bgImage.visible = false;
                Registry.player1Score = 0;
                Registry.player2Score = 0;
                Registry.lastPlayerWon = 0;
                FlxG.switchState(new Menu());
            }
			return;
		}

		updateCountdown(elapsed);
		updateScoreText();

        if (stage.someoneIsDead) {
        // TODO: Probably want to display a "Player 1 wins!" message here
            FlxG.switchState(new PlayState());
        }


		// remove stale hitboxes/attacks
		player1.removeStale();
		player2.removeStale();

		// do collision
		for (hitbox in player1.activeHitboxes) {
			player2.collide(hitbox);
		}

		for (hitbox in player2.activeHitboxes) {
			player1.collide(hitbox);
		}

		player1.collidePlayers(player2);
		player2.collidePlayers(player1);

		// tick
		player1.tick();
		player2.tick();
	}

	public function activateHitbox(hitbox:Hitbox) {
		hitbox.player.activeHitboxes.add(hitbox);
		add(hitbox.sprite);
	}
}
