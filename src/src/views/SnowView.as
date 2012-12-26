/**
 *
 * @author v.pavkin
 */
package views {

import clock.SecondsTimer;

import flash.display.Sprite;
import flash.events.Event;

import views.snow.Snowflake;

public class SnowView extends Sprite {

	public static const DEFAULT_FLAKES_COUNT:uint = 30;

	private var _flakes:Vector.<Snowflake>;
	private var _timer:SecondsTimer;

	public function SnowView(timer:SecondsTimer) {
		_timer = timer;

		if (stage)
			start();
		else
			addEventListener(Event.ADDED_TO_STAGE, start);
	}

	public function start(e:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, start);

		_flakes = new Vector.<Snowflake>(DEFAULT_FLAKES_COUNT);
		for (var i:int = 0; i < DEFAULT_FLAKES_COUNT; i++) {
			var s:Snowflake = new Snowflake(_timer);
			_flakes[i] = s;
			addChild(s);
			s.start();
		}
	}
}
}

