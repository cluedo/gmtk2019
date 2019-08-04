package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import Player.PlayerType;

class PlayState extends FlxState
{
	public static var currentGame:PlayState;

	public var stage:Stage;

	public var player1:Player;
	public var player2:Player;

	public var activeHitboxes:List<Hitbox>;

	public var countdownText:FlxText;
	public var timeToGameStart:Float;
	public var countdownBeepSound:FlxSound;

	public var player1ScoreText:FlxText;
	public var player2ScoreText:FlxText;

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
		add(player1);
		add(player1.arrowSprite);

		player2 = new Player(stage,
							 Player.PlayerType.PLAYER_TWO,
							 Player.InputType.KEYBOARD_TWO);
		add(player2);
		add(player2.arrowSprite);

		activeHitboxes = new List<Hitbox>();

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
