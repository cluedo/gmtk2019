package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.addons.display.FlxBackdrop;

class Menu extends FlxState
{
	var titleText:FlxText;
    var helpText:FlxText;
	var singleplayerText:FlxText;
	var multiplayerText:FlxText;
    var bgImage:FlxBackdrop;

	override public function create():Void
	{
		super.create();

        bgImage = new FlxBackdrop(AssetPaths.background__png);
        add(bgImage);
		bgColor = new FlxColor(0xFF000000);
		titleText = new FlxText(0, 150, 800, "Super Line Fighter 1D");
		titleText.setFormat(AssetPaths.squaredpixel__ttf, 48, FlxColor.RED, FlxTextAlign.CENTER);
		titleText.width += 10;
		add(titleText);
		helpText = new FlxText(0, 200, 800, "Click mode to start");
		helpText.setFormat(AssetPaths.squaredpixel__ttf, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(helpText);
        singleplayerText = new FlxText(0, 250, 1024, "Single player");
		singleplayerText.setFormat(AssetPaths.squaredpixel__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(singleplayerText);
        multiplayerText = new FlxText(0, 350, 1024, "Multiplayer");
		multiplayerText.setFormat(AssetPaths.squaredpixel__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(multiplayerText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(singleplayerText))
		{
			Registry.singlePlayer = true;
			FlxG.switchState(new PlayState());
		}
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(multiplayerText))
		{
			Registry.singlePlayer = false;
			FlxG.switchState(new PlayState());
		}
	}
}
