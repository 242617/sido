/**
 *
 * @author v.pavkin
 */
package views {
import clock.SecondsTimer;

import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Matrix;

public class BGView extends Sprite {

	private var _colors:Array = [
		[0xcc, 0x33, 0x00],
		[0x99, 0xff, 0x00],
		[0x00, 0x33, 0x00]
	];
	private var _rates:Array = [0x25, 0x77, 0xa9];
	private var _focalRatio:Number = 0;

	private var _colorMods:Array = [
		[1, -1, 1],
		[1, 1, -1],
		[1, -1, 1]
	];
	private var _rateMod:int = 1;

	private var _timer:SecondsTimer;

	public function BGView(timer:SecondsTimer) {
		_timer = timer;

		if (stage) start();
		else addEventListener(Event.ADDED_TO_STAGE, start);
	}

	private function start(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, start);
		_timer.addEventListener(TimerEvent.TIMER, onTimer)
	}

	private function onTimer(event:Event):void {

		var m:Matrix = new Matrix();
		m.createGradientBox(this.stage.stageWidth, this.stage.stageHeight, 3.14, 0, 0);

		this.graphics.clear();
		this.graphics.beginGradientFill(GradientType.RADIAL, _colors.map(function (item:*, index:int, array:Array):* {
			return item[2] + 0x100 * item[1] + 0x10000 * item[0];
		}), [1, 1, 1], _rates, m, SpreadMethod.REFLECT, InterpolationMethod.RGB, _focalRatio);
		this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		this.graphics.endFill();

		this.modifyColors();
		this.modifyRates();
	}

	private static const K:int = 5;

	private function modifyColors():void {
		for (var i:int = 0; i < _colors.length; i++) {
			for (var j:int = 0; j < _colors[i].length; j++) {
				if (isOutRate(_colors[i][j] + K * _colorMods[i][j]))
					_colorMods[i][j] = -_colorMods[i][j];
				_colors[i][j] += K * _colorMods[i][j];
			}
		}
		trace(_colors.map(function (item:*, index:int, array:Array):* {
			return item.toString(16);
		}));
	}
	private function isOutColor(color:uint):Boolean {
		return color < 0x00000 || color > 0xff1000;
	}
	private function modifyRates():void {
		for (var i:int = 0; i < _rates.length; i++) {
			if (isOutRate(_rates[i] + K * _rateMod))
				_rateMod = -_rateMod;
			_rates[i] += K * _rateMod;
		}
		//trace(_rates);
	}
	private function isOutRate(color:uint):Boolean {
		return color < 0 || color >= 0xff;
	}
}
}
